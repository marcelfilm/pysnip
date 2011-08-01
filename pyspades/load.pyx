# Copyright (c) Mathias Kaerlev 2011.

# This file is part of pyspades.

# pyspades is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# pyspades is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with pyspades.  If not, see <http://www.gnu.org/licenses/>.

from pyspades.common cimport allocate_memory

cpdef tuple get_color_tuple(int color):
    cdef int r, g, b, a
    b = color & 0xFF
    g = (color & 0xFF00) >> 8
    r = (color & 0xFF0000) >> 16
    a = (((color & 0xFF000000) >> 24) / 128.0) * 255
    return (r, g, b, a)

cdef inline int make_color(int r, int g, int b, a):
    return b | (g << 8) | (r << 16) | (<int>((a / 255.0) * 128) << 24)

import random
import time

cdef inline int get_z(int x, int y, MapData * map, int start = 0):
    cdef int z
    for z in range(start, 64):
        if get_solid(x, y, z, map):
            return z
    return 0

cdef class Generator:
    cdef MapGenerator * generator
    cdef public:
        bint done
    
    def __init__(self, VXLData data):
        self.done = False
        self.generator = create_map_generator(data.map)
    
    def get_data(self, int columns = 2):
        if self.done:
            return None
        value = get_generator_data(self.generator, columns)
        if not value:
            self.done = True
            return None
        return value
    
    def __dealloc__(self):
        delete_map_generator(self.generator)

cdef class VXLData:
    def __init__(self, fp = None):
        cdef unsigned char * c_data
        if fp is not None:
            data = fp.read()
            c_data = data
        else:
            c_data = NULL
        self.map = load_vxl(c_data)
    
    def load_vxl(self, c_data = None):
        self.map = load_vxl(c_data)
    
    def get_point(self, int x, int y, int z):
        return (get_solid(x, y, z, self.map), get_color_tuple(get_color(
            x, y, z, self.map)))
    
    def copy(self):
        cdef VXLData map = VXLData()
        map.map = copy_map(self.map)
        return map
    
    cpdef int get_solid(self, int x, int y, int z):
        if x < 0 or x >= 512 or y < 0 or y >= 512 or z < 0 or z >= 64:
            return 0
        return get_solid(x, y, z, self.map)
    
    cpdef int get_color(self, int x, int y, int z):
        if x < 0 or x >= 512 or y < 0 or y >= 512 or z < 0 or z >= 64:
            return 0
        return get_color(x, y, z, self.map)
    
    cpdef int get_z(self, int x, int y, int start = 0):
        return get_z(x, y, self.map, start)
    
    cpdef int get_height(self, int x, int y):
        cdef int h_z
        for h_z in range(63, -1, -1):
            if not get_solid(x, y, h_z, self.map):
                return h_z + 1
        return 0
    
    def remove_point(self, int x, int y, int z, bint user = True, 
                     bint no_collapse = False):
        if x < 0 or x >= 512 or y < 0 or y >= 512 or z < 0 or z >= 64:
            return
        if user and z >= 62:
            return
        if not get_solid(x, y, z, self.map):
            return
        set_point(x, y, z, self.map, 0, 0)
        if no_collapse:
            return
        start = time.time()
        for node_x, node_y, node_z in self.get_neighbors(x, y, z):
            if node_z >= 62:
                continue
            self.check_node(node_x, node_y, node_z, True)
        taken = time.time() - start
        if taken > 0.1:
            print 'removing block at', x, y, z, 'took:', taken
    
    def remove_point_unsafe(self, int x, int y, int z):
        set_point(x, y, z, self.map, 0, 0)
            
    cpdef bint has_neighbors(self, int x, int y, int z):
        return (
            self.get_solid(x + 1, y, z) or
            self.get_solid(x - 1, y, z) or
            self.get_solid(x, y + 1, z) or
            self.get_solid(x, y - 1, z) or
            self.get_solid(x, y, z + 1) or
            self.get_solid(x, y, z - 1)
        )
    
    cpdef bint is_surface(self, int x, int y, int z):
        return (
            not self.get_solid(x, y, z - 1) or
            not self.get_solid(x, y, z + 1) or
            not self.get_solid(x + 1, y, z) or
            not self.get_solid(x - 1, y, z) or
            not self.get_solid(x, y + 1, z) or
            not self.get_solid(x, y - 1, z)
        )
    
    cpdef list get_neighbors(self, int x, int y, int z):
            cdef list neighbors = []
            for (node_x, node_y, node_z) in ((x, y, z - 1),
                                             (x, y - 1, z),
                                             (x, y + 1, z),
                                             (x - 1, y, z),
                                             (x + 1, y, z),
                                             (x, y, z + 1)):
                if self.get_solid(node_x, node_y, node_z):
                    neighbors.append((node_x, node_y, node_z))
            return neighbors
    
    cpdef bint check_node(self, int x, int y, int z, bint destroy = False):
        return check_node(x, y, z, self.map, destroy)
    
    cpdef bint set_point(self, int x, int y, int z, tuple color_tuple, 
                         bint user = True):
        if user and (z not in xrange(62) or not self.has_neighbors(x, y, z)):
            return False
        r, g, b, a = color_tuple
        cdef int color = make_color(r, g, b, a)
        set_point(x, y, z, self.map, 1, color)
        return True
    
    cpdef bint set_point_unsafe(self, int x, int y, int z, tuple color_tuple):
        r, g, b, a = color_tuple
        cdef int color = make_color(r, g, b, a)
        set_point(x, y, z, self.map, 1, color)
        return True
    
    def set_point_unsafe_int(self, int x, int y, int z, int color):
        set_point(x, y, z, self.map, 1, color)
    
    def get_overview(self, int z = -1):
        cdef unsigned int * data
        data_python = allocate_memory(sizeof(int[512][512]), <char**>&data)
        cdef unsigned int i, x, y, r, g, b, a, color
        i = 0
        cdef int current_z
        if z == -1:
            a = 255
        else:
            current_z = z
        for y in range(512):
            for x in range(512):
                if z == -1:
                    current_z = get_z(x, y, self.map)
                else:
                    if get_solid(x, y, z, self.map):
                        a = 255
                    else:
                        a = 0
                color = get_color(x, y, current_z, self.map)
                data[i] = (color & 0x00FFFFFF) | (a << 24)
                i += 1
        return data_python
    
    def set_overview(self, data_str, int z):
        cdef unsigned int * data = <unsigned int*>(<char*>data_str)
        cdef unsigned int x, y, r, g, b, a, color, i, new_color
        i = 0
        for y in range(512):
            for x in range(512):
                color = data[i]
                a = (color & <unsigned int>0xFF000000) >> 24
                if a == 0:
                    set_point(x, y, z, self.map, 0, 0)
                else:
                    set_point(x, y, z, self.map, 1, color)
                i += 1
    
    def generate(self):
        start = time.time()
        data = save_vxl(self.map)
        dt = time.time() - start
        if dt > 1.0:
            print 'VXLData.generate() took %s' % (dt)
        return data
    
    def get_generator(self):
        return Generator(self)
    
    def __dealloc__(self):
        cdef MapData * map
        if self.map != NULL:
            map = self.map
            self.map = NULL
            delete_vxl(map)