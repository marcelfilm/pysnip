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

"""
Reads/writes bytes
"""

cdef extern from "bytes_c.cpp":
    char read_byte(char * data)
    unsigned char read_ubyte(char * data)
    short read_short(char * data, int big_endian)
    unsigned short read_ushort(char * data, int big_endian)
    int read_int(char * data, int big_endian)
    unsigned int read_uint(char * data, int big_endian)
    double read_float(char * data, int big_endian)
    char * read_string(char * data)
    
    void * create_stream()
    void delete_stream(void * stream)
    void write_byte(void * stream, char value)
    void write_ubyte(void * stream, unsigned char value)
    void write_short(void * stream, short value, int big_endian)
    void write_ushort(void * stream, unsigned short value, int big_endian)
    void write_int(void * stream, int value, int big_endian)
    void write_uint(void * stream, unsigned int value, int big_endian)
    void write_float(void * stream, double value, int big_endian)
    void write_string(void * stream, char * data, size_t size)
    void write(void * stream, char * data, size_t size)
    object get_stream(void * stream)
    size_t get_stream_size(void * stream)

class NoDataLeft(Exception):
    pass
    
cdef class ByteReader:
    cdef char * data
    cdef char * pos
    cdef char * end
    cdef int start, size
    cdef object input
    def __init__(self, input, int start = 0, int size = -1):
        self.input = input
        self.data = input
        self.data += start
        self.pos = self.data
        if size == -1:
            size = len(input) - start
        self.size = size
        self.end = self.data + size
        self.start = start
    
    cdef char * check_available(self, int size) except NULL:
        cdef char * data = self.pos
        if data + size > self.end:
            raise NoDataLeft('not enough data')
        self.pos += size
        return data
    
    def read(self, int bytes = -1):
        cdef int left = self.dataLeft()
        if bytes == -1 or bytes > left:
            bytes = left
        ret = self.pos[:bytes]
        self.pos += bytes
        return ret
    
    def readByte(self, bint unsigned = False):
        cdef char * pos = self.check_available(1)
        if unsigned:
            return read_ubyte(pos)
        else:
            return read_byte(pos)
    
    def readShort(self, bint unsigned = False, bint big_endian = True):
        cdef char * pos = self.check_available(2)
        if unsigned:
            return read_ushort(pos, big_endian)
        else:
            return read_short(pos, big_endian)

    def readInt(self, bint unsigned = False, bint big_endian = True):
        cdef char * pos = self.check_available(4)
        if unsigned:
            return read_uint(pos, big_endian)
        else:
            return read_int(pos, big_endian)

    def readFloat(self, bint big_endian = True):
        cdef char * pos = self.check_available(4)
        return read_float(pos, big_endian)
    
    def readString(self):
        value = self.pos
        self.pos += len(value) + 1
        return value
        
    def readReader(self, int size = -1):
        cdef int left = self.dataLeft()
        if size == -1 or size > left:
            size = left
        cdef ByteReader reader = ByteReader(self.input, 
            (self.pos - self.data) + self.start, size)
        self.pos += size
        return reader
    
    cpdef int dataLeft(self):
        return self.end - self.pos
    
    cdef void _skip(self, int bytes):
        self.pos += bytes
        if self.pos > self.end:
            self.pos = self.end
        if self.pos < self.data:
            self.pos = self.data
    
    cpdef skipBytes(self, int bytes):
        self._skip(bytes)
        
    def rewind(self, value):
        self._skip(-value)
    
    def __len__(self):
        return self.size
    
    def __str__(self):
        return self.pos[:self.size]

cdef class ByteWriter:
    cdef void * stream
    
    def __init__(self):
        self.stream = create_stream()
        
    def write(self, data):
        write(self.stream, data, len(data))
    
    def writeByte(self, value, bint unsigned = False):
        if unsigned:
            write_ubyte(self.stream, value)
        else:
            write_byte(self.stream, value)

    def writeShort(self, value, bint unsigned = False, bint big_endian = True):
        if unsigned:
            write_ushort(self.stream, value, big_endian)
        else:
            write_short(self.stream, value, big_endian)

    def writeInt(self, value, bint unsigned = False, bint big_endian = True):
        if unsigned:
            write_uint(self.stream, value, big_endian)
        else:
            write_int(self.stream, value, big_endian)

    def writeFloat(self, value, bint big_endian = True):
        write_float(self.stream, value, big_endian)
    
    def writeString(self, value):
        write_string(self.stream, value, len(value))
    
    def __str__(self):
        return get_stream(self.stream)
    
    def __dealloc__(self):
        delete_stream(self.stream)
    
    def __len__(self):
        return get_stream_size(self.stream)