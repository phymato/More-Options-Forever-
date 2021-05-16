# More Options Forever!
Binding of Isaac: AB+ / Repentance mod
https://steamcommunity.com/sharedfiles/filedetails/?id=2469263643

# Description

Tired of having no choice when it comes to items? With this mod you can now pick one out of three, forever!!

- Bosses and Treasure Rooms drop a selection of three collectibles instead of one

CHANGES 5/17/21:
- Rewrote the thing so there's little less spaghetti code
- No longer despawns pedestals when touching an unrelated collectible
- More options spawn in boss rooms now
- Fixed a weird crash where picking up a collectible would cause a segmentation fault (don't ever use EntityList when making mods, EntityList sucks >:(
- Not yet implemented: spawning soul hearts or other pity items for having a now-useless More Options / There's Options item

- NOT YET THOROUGHLY TESTED: preventing the mod from overriding important items/drops, like the polaroid etc. Should theoretically work with imporant Repentance items too, but is untested.
If there's an item I forgot to exclude, you can add the ID to the main.lua file, located in Documents/My Games/Binding of Isaac Afterbirth+ Mods/more options forever blah blah (or wherever your mods are installed)

KNOWN BUGS:
- Bosses may sometimes drop one item instead of three
- Picking up an item from three doesn't immediately despawn the other two; even though they become disabled

# Install
- Clone/download this repo and throw it into your mods folder:
    - Navigate to C:\Users\your username\Documents\My Games\Binding of Isaac Afterbirth+ Mods\ (or whereever your mods are installed)
    - If you already have a different version of this mod downloaded from Steam, unsubscribe to it
    - Make a new folder for the mod, ex. "more options forever!"
    - Copy the main.lua into the mod folder

### Notes:
- Manually downloaded versions won't automatically update!
- Test versions that are uploaded here instead of the Steam Workshop may have significatly more bugs.
- If you want to go back to using the Steam Workshop version, be sure to delete the manually downloaded mod first.
