from twisted.internet.task import LoopingCall
    if value is None:
        return 'Day cycle speed is %s.' % connection.protocol.time_multiplier
    value = float(value)
    protocol.time_multiplier = value
        if protocol.day_loop.running:
        protocol.send_chat('Day cycle stopped.', irc = True)
    else:
        if not protocol.day_loop.running:
            protocol.day_loop.start(protocol.day_update_frequency)


@commands.name('daytime')
def day_time(connection, value = None):
    if value is not None:
        if not connection.admin:
            return 'No administrator rights!'
        value = float(value)
        if value < 0.0:
            raise ValueError()
        connection.protocol.current_time = value
        connection.protocol.update_day_color()
    f, i = modf(connection.protocol.current_time)
    return 'Time of day: %02d:%02d' % (i, f * 60)

commands.add(day_speed)
commands.add(day_time)
    return value - floor((value - min) / (max - min)) * (max - min)

def hsb_to_rgb(hue, sat, bri):
    bri_n = bri * 255.0
    if sat == 0.0:
	# greyscale
	r, g, b = bri_n, bri_n, bri_n
    else:
        hue_n = wrap(0.0, 1.0, hue) * 6 # wrap hue
        hue_i = floor(hue_n) # get integer part
        hue_f = hue_n - hue_i # fractional part
        if hue_i % 2 == 0:
            hue_f = 1.0 - hue_f
        m = bri_n * (1.0 - sat)
        n = bri_n * (1.0 - (sat * hue_f))
        if hue_i == 0 or hue_i == 6:
            r, g, b = bri_n, n, m
        elif hue_i == 1:
            r, g, b = n, bri_n, m
        elif hue_i == 2:
            r, g, b = m, bri_n, n
        elif hue_i == 3:
            r, g, b = m, n, bri_n
        elif hue_i == 4:
            r, g, b = n, m, bri_n
        elif hue_i == 5:
            r, g, b = bri_n, m, n
    return int(r), int(g), int(b)

def interpolate_rgb((r1, g1, b1), (r2, g2, b2), t):
    return (int(r1 + (r2 - r1) * t),
        int(g1 + (g2 - g1) * t),
        int(b1 + (b2 - b1) * t))

def interpolate_hsb((h1, s1, b1), (h2, s2, b2), t):
    return (h1 + (h2 - h1) * t, s1 + (s2 - s1) * t, b1 + (b2 - b1) * t)

def rgb_distance((r1, g1, b1), (r2, g2, b2)):
    return int(abs(r1 - r2) + abs(g1 - g2) + abs(b1 - b2))

        current_time = 0.00
        day_duration = 600.00
        time_multiplier = 1.0
        
            self.day_colors = [
                ( 0.00, (0.0,    0.0,  0.0 ), False),
                ( 5.00, (0.05,   0.77, 0.0 ), False),
                ( 6.00, (0.0694, 0.77, 0.78),  True),
                ( 6.30, (0.0361, 0.25, 0.95), False),
                ( 7.00, (0.56,   0.18, 0.94), False),
                (10.00, (0.5527, 0.24, 0.94), False),
                (12.00, (0.5527, 0.41, 0.95), False),
                (18.50, (0.56,   0.28, 0.96), False),
                (19.00, (0.15,   0.33, 0.87), False),
                (19.25, (0.10,   0.49, 0.94), False),
                (19.50, (0.1056, 0.69, 1.00), False),
                (21.50, (0.0,    0.69, 0.0 ),  True),
                (22.00, (0.0,    0.0,  0.0 ), False)
            ]
            self.time_step = 24.00 / (self.day_duration /
                self.day_update_frequency)
            self.target_color_index = 0
            self.next_color()
            self.day_loop.start(self.day_update_frequency)
            self.current_time += self.time_step * self.time_multiplier
            if self.current_time >= 24.00:
                self.current_time = wrap(0.00, 24.00, self.current_time)
            while (self.current_time < self.start_time or
                self.current_time >= self.target_time):
                self.next_color()
                self.target_time = self.target_time or 24.00
            t = ((self.current_time - self.start_time) /
                (self.target_time - self.start_time))
            if self.hsv_transition:
                new_color = interpolate_hsb(self.start_color, 
                    self.target_color, t)
                new_color = hsb_to_rgb(*new_color)
            else:
                new_color = interpolate_rgb(self.start_color, 
                    self.target_color, t)
            if (self.current_color is None or
                rgb_distance(self.current_color, new_color) > 3):
                self.current_color = new_color
        
        def next_color(self):
            self.start_time, self.start_color, _ = (
                self.day_colors[self.target_color_index])
            self.target_color_index = ((self.target_color_index + 1) %
                len(self.day_colors))
            self.target_time, self.target_color, self.hsv_transition = (
                self.day_colors[self.target_color_index])
            if not self.hsv_transition:
                self.start_color = hsb_to_rgb(*self.start_color)
                self.target_color = hsb_to_rgb(*self.target_color)
    