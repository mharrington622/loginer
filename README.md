# Loginer #

Loginer is a lua addon for Final Fantasy XI Windower that will log in your characters from the main menu, log them out and repeat.

## Usage ##

Please follow these steps:

1. Load the addon with the command `//lua l loginer`
2. Leave your cursor on the title menu's "Select Character" option.
3. Type the command `//login do <number>` where `<number>` is the number of characters you have and want to log in.  e.g.
	```
	//login do 3
	```
4. Unplug your keyboard and mouse/go take a walk/do anything **_EXCEPT_** touch your computer!  Due to how Windower works, the script expects things to be exactly where they are expected to be.  See below for more details.
5. When all characters are finished logging in, the addon will unload itself and should leave you on either the title menu or character select menu.

## How It Works ##

The Windower API wasn't designed to interface with many of the UI elements of the game.  This includes the title menu and character select menu.  Windower does allow code to trigger key presses, so that is what is being done.  On the menus, the script is only simulating keypresses with the information you provide to it.

## Known Issues ##

* I do not have any additional character slots to test deactivated Content IDs with, so there may be some issues once the script gets to those character slots.  If anything weird happens, use the command `//login stop`.  Then, log an issue letting me know what windows popped up so I can resolve it.
* After logging a character out, the script may sit on the title menu for a few seconds.  This is normal.
* If you leave this addon loaded while playing, you will automatically try to log out when moving to a new zone.  When all characters are finished logging in, the addon will unload itself!  If it does not, use the command `//lua u loginer`
