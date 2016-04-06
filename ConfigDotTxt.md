config.txt is a text file in [JSON](http://www.json.org/) format. You can edit it with any text editor such as Notepad, vi, emacs...

In the JSON format, each parameter contains a key name (for example "name", "map", or "max\_players") followed by the data, followed by a comma at the end. So a single entry looks like this

```
"name" : "pysnip server",
```

Make sure to have exactly one comma at the end of every entry except the last. _If you have a missing comma in the middle, multiple commas, or an extra comma at the end, pysnip will be unable to read the config and give tons of error messages when you run it._

### name ###

This is the name of the server given to the server browser(the AoS play page, 50D, Spadille, etc.) It is also accessible in the MOTD text with the keyword :

```
%(server_name)s
```

### motd ###

This text is the "message of the day," shown when players join the game.
Each comma-separated line corresponds to a line shown in the in-game chat.

```
       "Welcome to %(server_name)s! See /help for commands.",
        "Map is %(map_name)s by %(map_author)s.",
        "(server powered by pysnip)"
```

Each of the special keywords (**%(server\_name)s** etc.) corresponds to other parameters(server name, the map title and author).

### help ###

This is the text shown by the /help command. If not defined, /help will just display a list of the available commands.

### rules ###

This is the text shown by the /rules command.

### tips ###

A line picked at random from this text will be shown every tip\_frequency minutes.

### tip\_frequency ###

How often the tip will be shown, in minutes. 0 means no tips. Default 5.

### max\_players ###

The maximum number of players on the server. Don't go over 32 players; the AoS client is not designed to support more. Default 32.

### max\_connections\_per\_ip ###

Limits how many players can connect from the same IP address. 0 disables this limit. Default 0.

### cap\_limit ###

The number of intel captures before the game is won. Default 10.

### map ###

The name of a map to play, without the ".vxl" extension. The VXL files are stored in **<pysnip root>/maps**. If there is a .txt file with the same name it will be used to provide a title, author, and map metadata.

pysnip has a random map generator which can be accessed with the map name "random".

### respawn\_time ###

The number of seconds before a player respawns. Default 5.

### master ###

'true' allows your server to connect to the master server and be shown on server browsers. 'false' disables this, if you want a private game.

### friendly\_fire ###

true (without quotes) enables friendly fire.
false (without quotes) disables friendly fire.
"on\_grief" (with quotes) emulates vanilla AoS behavior: friendly fire is on after block destruction.

### grief\_friendly\_fire\_time ###

The number of seconds a player is vulnerable to friendly fire in "on\_grief" mode.

### teamswitch\_interval ###

Forces players to wait a number of minutes before being able to switch back again after they switched teams.

0 disables the cooldown.
"never" completely disables team switching, and you only get to pick a team when you join.

### passwords ###

User accounts and their associated passwords. When playing, a player may log into an account by typing

```
/login <password> 
```

pysnip provides two types of accounts currently: "admin" and "trusted". Each account can have a list of passwords:

```
"admin" : ["password","sesame","watermelon"],
"trusted" : ["semisecret","coolness"]
```

You can use different passwords for different people, so that the server may be easily secured if one of them turns rogue or loses the password.

The admin account can use all the admin commands and is safe from votekicking. Trusted users cannot be votekicked, but do not have any other powers.

### scripts ###

pysnip ships with a set of scripts you can use to customize the features of your server. They are loaded in order, "on top of" each other.

See [Scripts](Scripts.md) for more.

### ssh ###

This controls [ssh](http://en.wikipedia.org/wiki/Secure_Shell) access to the server.

### status\_server ###

This enables functionality that returns game status(players, teams, scores, etc.) as JSON data when an HTTP GET is requested.

### server\_prefix ###

When the server sends messages to users, the message is prefixed with the characters in server\_prefix.

### user\_blocks\_only ###

Controls whether users can affect the map's initial blocks.

### logfile ###

The file where the server log is recorded.

### balanced\_teams ###

If 0, any permutation of teams is allowed. If 1 or greater, team balance is enforced with the algorithm:

```
abs(green_team_players - blue_team_players) <= balanced_teams
```

### login\_retries ###

The number of /login attempts allowed before users are auto-kicked. Default 3.

### votekick\_percentage ###

The required votes to succesfully votekick a player, as a percentage of the total amount of players in the server. Default 25 (percent).

### votekick\_ban\_duration ###

The duration in minutes of a sucessful votekick ban. 0 means votekicks will only kick and not ban.

### irc ###

Enables an IRC chatbot that reports server events in the given channel.

### rollback\_on\_game\_end ###

If true and the rollback script is included, when a match ends (cap limit hit) a rollback of the entire map automatically begins, restoring it to its original state.