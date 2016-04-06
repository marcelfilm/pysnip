# Quick-start guide #

## Installation ##
### Windows (32/64-bit) ###

The recommended way to install pysnip on Windows is to use
the prebuilt binaries. Head over to the Downloads page and get the
most recent one and extract it to a preferable path.

If this doesn't work, you should try and install from source.

### Linux/OS X/BSD/whatever ###

On these platforms, you have to install from source. Usually, this
involves installing the dependencies (see README.txt) using your
package manager, cloning the repository with Mercurial, then running build.sh (build.bat on Windows).

## Running ##
Edit config.txt to your liking. If you don't want to go too deep with
the configuration, just edit "name", "map" and the admin password
("replaceme"). To change game modes, set the "game\_mode" variable to what you would like to play: e.g. "runningman" "tdm" "tc".

On Windows, run run.exe, and on other platforms, run run\_server.sh.

Your server should hopefully be running now!