### Introduction ###

These files are placed alongside the .vxl - when pysnip loads the map, they are checked.

## Example ##

```

name = 'Mapname'
version = '1.0'
author = 'Anonymous'
description = ('My description goes here.')
extensions = { 'water_damage' : 2,
               'boundary_damage' : {'left' : 64,
                                    'right' : 448,
                                    'top' : 128,
                                    'bottom' : 384,
                                    'damage': 1 } }
```

## Water Damage ##

This activates once per second when the player is at water level(z>=61). The player takes the listed amount of HP damage and will die at 0 health.

## Boundary Damage ##

This defines a "safe area" for play. Players who wander outside take damage.

It activates once per second when the player is OUTSIDE the rectangle coordinates. The player takes the listed amount of HP damage and will die at 0 health.