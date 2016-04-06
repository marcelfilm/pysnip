## Overview ##

Where commands are marked **Admin** the server administrator must /login first, or connect over SSH.

Any commands that take players' names will also work with their id numbers, e.g.

```
/kick Deuce9
/kick #9
```
will do the same thing. _You must use the # marker if you are using id numbers, /kick 9 will instead try to kick a player with '9' in their name._

About commands:
  * All commands start with a slash '/'.
  * `<angled brackets>` mean an argument is required and the command won't  work without it.
  * Arguments in `[brackets]` are optional and can be skipped.
  * Some commands have "aliases".  These aliases are shown in _italics_ and can be used instead of the command.


---


# Regular user commands #
### /login `<password>` ###

Logs into the server for access to admin features. You will be kicked out after a number of failed attempts, configured in **config.txt**.

### /votekick `<player>` `[reason]` ###

Initiates a votekick with an optional reason. To mantain a consistent behavior with the vanilla server, numbers are assumed to be ids.

Players can agree to the votekick by using the /y command.

```
/votekick Deuce2 griefing
/votekick 2 griefing          "all of these do the same thing"
/votekick #2 griefing
```

### /cancel ###

Cancels the current votekick. You can only cancel a votekick you've started, but admins can cancel any votekick.

### /pm `<player>` `<message>` ###

Private messaging.

```
Deuce2 types "/pm Deuce13 yo"
Deuce2 sees "PM sent to Deuce13"
Deuce13 receives "PM from Deuce2: yo"
```

### /time ###

Shows how much time is left in the current map.

### /mapname ###

Shows the name of the current map.

### /server ###

Shows the current name of the server, and the aos:// number for it.  Useful for connecting to a server that has master broadcast turned off.

### /help ###

Displays custom help is it's defined in **config.txt**, otherwise shows a list of all the available commands.

### /rules ###

Displays the server rules text from **config.txt**.


---


# Admin commands #
### /kick `<player>` `[reason]` ###

Kicks a player, with an optional reason given.

```
/kick Deuce2 griefing
/kick #2 griefing
```

### /ban `<player>` `[duration]` `[reason]` ###

Kicks and bans a player.

You can specify the duration of the ban in minutes, and also add a reason. The length of the ban is in minutes, and '0' means a permanent ban. Unless changed in **config.txt**, duration defaults to 1 day.

Bans are by IP address and are logged into **bans.txt**.

```
/ban Deuce2 60 griefing       "banned for 1 hour for griefing"
/ban Deuce21 0 hacking        "Deuce21 permabanned for hacking"
/ban #21                      "ban with default duration and no reason"
```

### /undoban ###

This command undoes the last ban.  If you run it multiple times, it will continue to delete the last ban added to the ban list.

### /unban `<ip>` ###

Unbans an IP, and removes the entry from **bans.txt**.

```
/unban 12.34.56.78
/unban 127.0.0.1
```

### /mute `<player>` ###
### /unmute `<player>` ###

Mutes or unmutes a player, preventing chat.

```
/mute Deuce0
/mute #0
```

### /say `<message>` ###

The server broadcasts a message to all players.

### /kill `<player>` ###

Instantly kills a player.

### /heal `<player>` ###

Heals and restocks a player.

### /teleport `<player1>` `[player2]` ###
### /tpsilent `<player1>` `[player2]` ###

Teleports yourself to player1, or teleports player1 to player2.

_/tp is an alias of /teleport_

_/tps is an alias of /tpsilent_

```
/teleport Deuce0    "teleport me to Deuce0. See if he's griefing!"
/teleport #11 Deuce12    "teleport player id 11 to Deuce12."
/tp #25 Deuce7 "teleport player with id 25 to Deuce7."
/tpsilent Deuce0
/tpsilent #11 Deuce12
```

### /goto `<grid coordinate>` ###

Teleports you to the grid coordinate you select (eg. A1, E3, etc.)

### /invisible `<player>` ###

_/invis is an alias of /invisible_

Makes the player invisible to other players and turns off fall damage.

```
/invisible
/invisible bcoolface
```

### /god `[player]` ###

Toggles god mode on yourself or a given player.

```
/god
/god Deuce20
```

### /godbuild `[player]` ###

Toggles god building for the player listed (or yourself if no player is specified).  God build allows you to place blocks that can only be destroyed by players with god mode on.

```
/godbuild
/godbuild Deuce20
```

### /map `<maps>` ###

You can use the /map command to manually set a map rotation in game or in IRC.

```
/map happytime                        "Sets the map to "happytime".  The rotation will now only play "happytime""
/map happytime sillytime funtime      "Sets the map rotation to "happytime", "sillytime", and then "funtime"."
/map "super fun time" "happy time"    "You can use quotes to include maps that have spaces in their names."
```

### /advance ###

The /advance command will manually change the map to the next one in the rotation.

### /revertrotation ###

This command will revert your map rotation to whatever it was before you manually changed it.

### /setbalance `<difference>` ###

Changes the team balance strictness.

A value of 0 disables team balance, while greater numbers specify how many 'extra' players a team is allowed to have before it locks new players out.

```
/set_balance 0      "both teams are open"
/set_balance 1      "at most one extra person on a team"
```

### /switch `[player]` ###

Switches yourself or a target player to the opposite team, bypassing the team balance checks.

### /lock `<team>` ###
### /unlock `<team>` ###

Locks or unlocks a team, "green" or "blue", preventing players from joining it.

```
/lock green      "Green team is now locked"
/unlock blue     "Blue team is now unlocked"
```

### /resetgame ###

Resets the game and score counter.

### /timelimit `<time>` ###

Sets the time left on a map to the time you specify (in minutes)

### /togglebuild ###

Toggles players' ability to both build and destroy blocks. God-mode players are not restricted.

### /togglekill ###

Toggles the ability to kill players.

### /toggleteamkill ###

Toggles friendly fire on and off. Team kill does not behave like in the regular AoS server, it is either always on or always off.

### /fog `<R> <G> <B>` ###

This command allows you to set the fog to any color you'd like by specifying the RGB (Red/Green/Blue) values.

Examples:

  * 0 0 0: Black
  * 255 255 255: White
  * 128 232 255: Default (light blue)

### /unstick ###

This command will look for the nearest possible location that allows three blocks standing room and teleport the player there.


---

# Extensions #
These commands will only work if the specific modules are plugged in. You can take them out or include those you want in the 'scripts' section of **config.txt**

### /accuracy `[player]` ###
**Script: aimbot2.py**

When run, the accuracy command will tell you the specified player's accuracy (or your own if no player is specified) in each of the three weapons.

### /airstrike `<grid coordinate>` ###
**Script: airstrike.py**

_/a is an alias of /airstrike_

If this feature is enabled, players with a combined kill and capture score of 15, and a kill streak of 6 (kills in a row without dying) will be able to launch an airstrike on the indicated grid location.

The airstrike lasts about 20 seconds and will thoroughly cover the surface of the grid square, but it will not affect defenders buried deep below.

### /disco ###
**Script: disco.py**

If this feature is enabled, admins can turn on disco mode by typing /disco in game.  This will cause the sky (fog color) to flash in different colors wildly until you stop it (by typing /disco again).

### /griefcheck `<player> [time in minutes]` ###
**Script: blockinfo.py**

_/gc is an alias of /griefcheck_

If this feature is enabled, admins can perform a check to see if a player has been griefing (defined as destroying friendly blocks).  If no time is specified, 2 minutes is the default.  This command is more useful in IRC than in game because of color coding.

### /medkit ###
**Script: medkit.py**

_/m is an alias of /medkit_

If medkits are enabled, players will spawn with 1 (by default, although this can be changed in the plugin), and they will be able to use it by typing /medkit in game.  Each medkit heals 40hp (by default, this can also be changed).

### /protect `[grid coordinate]` ###
**Script: protect.py**

Makes the specified area grief-safe, disabling building and destroying inside it. Passing no coordinates instead unprotects all areas. Players with god mode are not affected and can build as normal.

```
/protect A1        "the corner of the map is untouchable"
/protect           "all areas back to normal"
```

### /ratio `[player]` ###
**Script: ratio.py**

This script keeps track of kills and deaths, and will give your your kill/death ratio if you type /ratio by itself.  If you'd like to know the kill/death ratio of another player, use their name instead.

### /rollback `[grid coordinate]` ###
**Script: rollback.py**

This resets the map to its original layout when it was first loaded.

Using a grid coordinate limits the rollback to that specific area, for localized repairs.

```
/rollback         "do-over of the whole map"
/rollback E5      "rebuilds e.g. the church in the Normandie map"
```

### /squad `[name]` ###
**Script: squad.py**

If squads are enabled, they allow a user to spawn with the other people in his squad at the cost of a longer respawn time.
  * Typing /squad with no parameters will list your current squad (if you're in one), all other squads and their members, and all currently unassigned members.
  * Typing /squad example would cause you to join squad "example".
  * Typing /squad none will cause you to leave a squad.