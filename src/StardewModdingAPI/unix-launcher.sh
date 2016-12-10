#!/bin/bash
# MonoKickstart Shell Script
# Written by Ethan "flibitijibibo" Lee
# Modified for StardewModdingAPI by Viz and Pathoschild

# Move to script's directory
cd "`dirname "$0"`"

# Get the system architecture
UNAME=`uname`
ARCH=`uname -m`

# MonoKickstart picks the right libfolder, so just execute the right binary.
if [ "$UNAME" == "Darwin" ]; then
	# ... Except on OSX.
	export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:./osx/

	# El Capitan is a total idiot and wipes this variable out, making the
	# Steam overlay disappear. This sidesteps "System Integrity Protection"
	# and resets the variable with Valve's own variable (they provided this
	# fix by the way, thanks Valve!). Note that you will need to update your
	# launch configuration to the script location, NOT just the app location
	# (i.e. Kick.app/Contents/MacOS/Kick, not just Kick.app).
	# -flibit
	if [ "$STEAM_DYLD_INSERT_LIBRARIES" != "" ] && [ "$DYLD_INSERT_LIBRARIES" == "" ]; then
		export DYLD_INSERT_LIBRARIES="$STEAM_DYLD_INSERT_LIBRARIES"
	fi

	ln -sf mcs.bin.osx mcs
	cp StardewValley.bin.osx StardewModdingAPI.bin.osx
	open -a Terminal ./StardewModdingAPI.bin.osx $@
else
	# get launcher
	COMMAND=""
	if [ "$ARCH" == "x86_64" ]; then
		ln -sf mcs.bin.x86_64 mcs
		cp StardewValley.bin.x86_64 StardewModdingAPI.bin.x86_64
		COMMAND="./StardewModdingAPI.bin.x86_64 $@"
	else
		ln -sf mcs.bin.x86 mcs
		cp StardewValley.bin.x86 StardewModdingAPI.bin.x86
		COMMAND="./StardewModdingAPI.bin.x86 $@"
	fi

	# open terminal
	if command -v x-terminal-emulator 2>/dev/null; then
		x-terminal-emulator -e "$COMMAND"
	elif command -v gnome-terminal 2>/dev/null; then
		gnome-terminal -e "$COMMAND"
	elif command -v xterm 2>/dev/null; then
		xterm -e "$COMMAND"
	elif command -v konsole 2>/dev/null; then
		konsole -e "$COMMAND"
	elif command -v terminal 2>/dev/null; then
		terminal -e "$COMMAND"
	else
		$COMMAND
	fi
fi
