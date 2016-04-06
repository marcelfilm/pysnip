Some scripts add new commands; others add new configuration parameters, which you can add to config.txt. In each case the new features are listed.

To add or remove a script change the "scripts" entry in config.txt:

```
"scripts" : [
        "welcome",
        "rollback",
        "trusted",
        "autohelp",
        "protect",
        "map_extensions",
        "airstrike",
        "melee",
        "squad",
        "disco",
        "savemap"
    ],
```

Each of the lines in the middle ("welcome", "rollback", etc.) is one script.


---

# TDM #

Enables the TDM game mode. CTF gameplay remains but you can choose whether it has meaning to the score by changing point values and the capture limit.

# Config #

### kill\_limit ###

The number of kills needed to win(default 100).

### intel\_points ###

The point value of intel in kills(default 10).

# Commands #

### /score ###

Display the TDM score; done automatically on spawn.



---

# TC #

Enables the TC game mode. In this mode the map is "controlled" by placing or removing blocks - so building on new ground is one way to gain territory, but tunneling into enemy territory and destroying their structures can be even better, since it removes control from them at the same time.

Each x/y coordinate controlled goes towards a "sector" score - each grid area is a sector. Controlling more blocks than the opponent wins the sector. Each sector controlled is worth 1 point per tick(of 30 seconds).

Scoring only adds the _balance_ of points: If Green and Blue control equal amounts of area, no points are added. If Green controls 1 more territory it gains 1 point per tick.

CTF gameplay remains active but you can add a high cap limit to discourage it.

# Config #

### score\_limit ###

The point score needed to win(default 100).

### territory\_update\_time ###

The tick time to award points and report a new score(default 30 seconds).

### min\_blocks\_to\_capture ###

The minimum number of blocks to capture an area(default 10).

# Commands #

### /score ###

Display the TC score; done automatically after territory updates.


---

# Squad #

This script emulates the squad feature seen in the Battlefield series; at the expense of longer respawn times, players can spawn with their friends.

# Config #

### squad\_respawn\_time ###

The number of seconds before a player respawns when following other players. Default 8.

### squad\_size ###

The maximum number of players allowed in a squad. Default 4.

### auto\_squad ###

Most players are unaware of the squad feature; this toggle automatically groups up players in squads named phonetically("Alpha, "Bravo", "Charlie", etc.) at login time. Players can still opt out with /squad none, or form their own named squads. Default true.

# Commands #

### /squad `[squad name or none]` ###
### /follow `<player name>` ###

Each squad has a name. To start a squad use "/squad [squadname](squadname.md)". Any name or number can be used. To see the squadlist type "/squad" without parameters.

Server operators can choose the maximum number of people in a squad and you will be told if the squad is full.

If you have a large squad and there is a specific person you prefer to spawn with, you can specify this with /follow. /follow will auto-join the squad if it exists; you can't follow players not in a squad. Otherwise it will pick a random living squad mate at spawn time. If all squad members are dead, you'll spawn in the base. Being in a squad increases your respawn time.

To stop following anyone and spawn normally, use "/squad none".

```
/squad abc          "in squad abc"
/follow Deuce12    "in Deuce12's squad, preferring to spawn with him"
/squad none          "back to normal"
/squad            "list all squads"
```