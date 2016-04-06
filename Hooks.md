# Connection Hooks #
_Thanks to Danko for the infomation_

### on\_join(self) ###
Executed when player (self) has loaded the map
```
#This should prevent anyone from joining the server
def on_join(self):
    self.disconnect()
    return connection.on_join(self)
```

---


### on\_login(self, name) ###
Executed when player (self) has entered the game and the server has his name
```
#This will auto-disconnect anyone who joins named rambo
def on_login(self, name):
    if name == "rambo":
        self.disconnect()						
    return connection.on_login(self, name) 
#This line will continue passing the information to other scripts 
#that might be using on_login as well, not doing this or doing it
#wrong will "swallow" the hook
```

---

### on\_spawn(self, pos) ###
Executed every time a player (self) spawns. pos is the coordinates in a (x, y, z) tuple

```
def on_spawn(self, pos):
#Immediately after the player spawns, check:
    if self.weapon == WEAPON_SMG:
#If the player spawns holding an SMG then
        return self.team.smg_x, self.team.smg_y, self.team.smg_z
#Move the spawned player to his team's smg spawn point
    return connection.on_spawn(self, pos)
#Don't swallow the hook!
```


---

### on\_spawn\_location(self, pos) ###
Same as above, but it handled before the player (self) is actually spawned (given weapon, placed at coordinates) you can return an (x, y, z) tuple as the new spawn location

```
def on_spawn_location(self, pos):
#When the player spawns, check:
    if self.jailed:
#If the player has a variable named 'jailed' set to true then:
        return self.protocol.jail_x, self.protocol.jail_y, self.protocol.jail_z
#Spawn the player to (jail_x,jail_y,jail_z)
    return connection.on_spawn_location(self, pos)
#Don't swallow the hook!
```


---

### on\_chat(self, value, global\_message) ###
Executed when a player (self) speaks. value is the message, if global\_message is false, it is a team message.  You can return False to prevent the message, or return your own message.

```
def on_chat(self, value, global_message):
#When the player tries to send a message, check:
    if "poop" in value:
#If the player's message contains the word "poop" then:
        return False
#Do not allow message to send
    return connection.on_chat(self, value, global_message)
#DON'T SWALLOW THE HOOK!!!!!
```


---

### on\_command(self, command, parameters) ###
Executed when a player (self) uses a /command ingame.

```
def on_command(self, command, parameters):
#When the player tries to use a command, check:
    if command == "squad":
#If the player tries the command /squad then:
        self.send_chat("Squads are not enabled on this server!")
#Send that player a message saying it is disabled
    return connection.on_command(self, command, parameters)
#dsth
```


---

### on\_hit(self, hit\_amount, hit\_player, type) ###
Executed when a player (self), hits another player (hit\_player), for hit\_amount with weapon (type) type can be MELEE\_KILL, HEADSHOT\_KILL, or WEAPON\_KILL you can return False or your own value.

```
def on_hit(self, hit_amount, hit_player, type):
#When the player takes damage, check:
    value = connection.on_hit(self, hit_amount, hit_player, type)
#Check to see if any other scripts have anything to say
    if value is None:
#If they don't have anything to say then:
        value = 100
#Hit the victim for 100 points of damage!
    return value
#Return the variable value (this won't swallow the command, think about it!)
```


---

### on\_kill(self, killer, type) ###
Executed when a player (self), is killed by another player (killer) killer can be self (fall damage or suicide)!

```
def on_kill(self, killer, type):
#When the player dies, check:
    if self.builder:
#If victim's builder variable is True then:
        killer.kill(killer, WEAPON_KILL
#make the killer commit suicide
    return connection.on_kill(self, killer, type)
```


---


### on\_team\_join(self, team) ###
Executed when a player (self) joins a team (team) you can return False

```
def on_team_join(self, team):
#When the player joins a team, check:
    if team == self.protocol.green_team:
#If player joins green team then:
        self.send_chat("You're a zombie RAWR")
#tell player he is a zombie!
    return connection.on_team_join(self, team)
```


---

### on\_team\_leave(self) ###
Executed when a player (self) leaves a team.

```
def on_team_leave(self):
#When the player leaves a team, check:
    if self.team == self.protocol.blue_team:
#If player leaves the blue team then:
        for poorguy in self.protocol.blue_team.get_players():
#Get all the players on the blue team and:
            poorguy.kill(self, HEADSHOT_KILL)
#Kill them all with a headshot from the leaving player
    return connection.on_team_leave(self)
```


---

### on\_tool\_set\_attempt(self, tool) ###
Executed when a player (self) attempts to change tools
-tools can be SPADE\_TOOL, BLOCK\_TOOL, WEAPON\_TOOL, GRENADE\_TOOL
you can return False. (I don't think this will actually stop the player from changing weapons in the client?)

```
def on_tool_set_attempt(self, tool):
#When the player tries to change tools, check:
    if tool == GRENADE_TOOL:
#If player switched to GRENADE:
        self.explode()
#explode him (this is not a real function)
    return connection.on_tool_set_attempt(self, tool)
```


---

### on\_tool\_changed(self, tool) ###
Executed when a player (self) successfully changes tools
-tools can be SPADE\_TOOL, BLOCK\_TOOL, WEAPON\_TOOL, GRENADE\_TOOL

```
def on_tool_changed(self, tool):
#When the player does change tools, check:
    if tool == BLOCK_TOOL:
#If player switched to BLOCK:
        self.refill()
#refill his health and ammo
    return connection.on_tool_changed(self, tool)
```


---

### on\_grenade(self, time\_left) ###
Executed when a player (self) pulls the pin on the grenade (but before he pulls it), time\_left is the fuse you can return False.
```
def on_grenade(self, time_left):
#When the player activates a nade, check:
    self.refill()
#refill his health and ammo
    return connection.on_grenade(self, time_left)
```


---

### on\_grenade\_thrown(self, grenade) ###
Executed when a player (self) releases the grenade (grenade).

```
def on_grenade_thrown(self, grenade):
#When the player releases nade, check:
    grenade.time_left = grenade.time_left * 10
#Make the grenade last 10 times as long!
    return connection.on_grenade_thrown(self, grenade)
```


---

### on\_block\_build\_attempt(self, x, y, z) ###
Executed when a player (self) tries to place a block at coordinates x,y,z (the block's coords, not player's!)
> you can return False.

```
def on_block_build_attempt(self, x, y, z):
#When the player attempts to build, check:
    if self.team == self.protocol.blue_team:
#If player is on the blue team then:
        return False
#Don't let the player build
    return connection.on_block_build_attempt(self, x, y, z)	
```

---

### on\_block\_build(self, x, y, z) ###
Executed when a player (self) places a block at coordinates x,y,z (the block's coords, not player's!)

```
def on_block_build(self, x, y, z):
#When the player does build, check:
    if self.team == self.protocol.green_team:
#If player is on the green team then:
        self.refill()
#refill his health and ammo
    return connection.on_block_build(self, x, y, z)
```


---

### on\_block\_destroy(self, x, y, z, mode) ###
Executed when a player (self) tries to destroy a block at coordinates x,y,z (the block's coords, not player's!)
-mode can be DESTROY\_BLOCK, SPADE\_DESTROY, GRENADE\_DESTROY you can return False.

```
def on_block_destroy(self, x, y, z, mode):
#When the player tries to destroy a block, check:
#if self.score < 25 and mode == SPADE_TOOL:
#If the player has less than 25 kills and is using the spade tool then:
        self.send_chat("You need 25 kills to unlock your spade!")
#Tell him no!
        return False
#Tell the server NO!
    return connection.on_block_destroy(self, x, y, z, mode)
```

---

### on\_block\_removed(self, x, y, z) ###
Executed when a player (self) successfully destroys a block at coordinates x,y,z (the block's coords, not player's!)
-will execute on every block in a SPADE\_DESTROY (3 blocks) or a GRENADE\_DESTROY (9 blocks)

```
def on_block_removed(self, x, y, z):
#When the player does remove a block, check:
    flag = self.team.other.flag
#Get the other teams flag and:
    if flag.player is self:
#check to see if player is holding it!
        self.hit(-5)
#heal 5 points per block removed
    return connection.on_block_removed(self, x, y, z)
```

---

### on\_refill(self) ###
Executed when a player (self) refills ammo and health (usually at a tent) you can return False.

```
def on_refill(self):
#When the player is refilled, check:
    self.set_location_safe(self.teleport_destination)
#Teleport the player to a teleport destination if it is not blocked off
    return connection.on_refill(self)
```

---

### on\_color\_set\_attempt(self, color) ###
> Executed when a player (self) attempts to change block color (color)
> > you can return False. (I don't think this will actually stop the player from changing block color in the client?)

---

### on\_color\_set(self, color) ###

> Executed when a player (self) successfully changes block color (color)

---

### on\_flag\_take(self) ###
> Executed when a player (self) attempts to grab the enemy intel
> > you can return False.

---

### on\_flag\_capture(self) ###

> Executed when a player (self) attempts to capture the enemy intel
> > you can return False.

---

### on\_flag\_drop(self) ###

> Executed when a player (self) drops the enemy intel (usually dying)

---

### on\_hack\_attempt(self, reason) ###
> Executed when a player (self) sends illegitimate information to the server
> > reason can be Invalid orientation data received, Invalid position data received, or Rapid Hack Detected

---

### on\_position\_update(self) ###

> Executed when a player's (self) position is updated
> > if you've ever been warped back to the same point endlessly, that's how often it's called

---

### on\_weapon\_set(self, value) ###

> Executed when a player (self) attempts to change weapon class
> > -value can be RIFLE\_WEAPON, SMG\_WEAPON, SHOTGUN\_WEAPON
> > you can return False. (With some weird effects)

---

### on\_fall(self, damage) ###
Executed when a player (self) falls enough to take damage (damage) you can return False or your own damage amount.

```
def on_fall(self, damage):
#When the player takes fall damage, check:
    value = connection.on_fall(self, damage)
#Take other scripts and see if they return any value
    if value is None:
#If they don't, then:
        value = 10
#make value = 10 hp
    return value
#return value
```

---

### on\_reset(self) ###

> Executed when a player (self) is reset (this happens after they leave the game)

---

### on\_orientation\_update(self, x, y, z) ###
> Executed when a player's (self) orientation is updated
> > you can return an (x, y, z) tuple to change orientation

---

### on\_shoot\_set(self, fire) ###

> Executed when a player (self) shoots or uses a spade

---

### on\_walk\_update(self, up, down, left, right) ###
> Executed when a player (self) is walking
> > you can return up, down, left, right

---

### on\_animation\_update(self, jump, crouch, sneak, sprint) ###

> Executed when a player (self) is doing stuff
> > you can return jump, crouch, sneak, sprint

---

# Protocol Hooks #
## (self) here is NOT the player, or any player. It is the protocol itself! ##

---

### def on\_cp\_capture(self, cp) ###
Executed when a control point (cp) is captured

---

### def on\_base\_spawn(self, x, y, z, base, entity\_id) ###
Executed when a base (base) is spawned at x,y,z

---

### def on\_flag\_spawn(self, x, y, z, flag, entity\_id) ###
Executed when a intel (flag) is spawned at x,y,z

---

### def on\_update\_entity(self, entity) ###
Executed when an entity (like a base or intel) moves (by placing blocks under it, etc)