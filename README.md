Source code for the upcoming game Mixorcerers

Mixorcerers is a turn based 1v1 game that combines rts elements with the unlimited power of a mage.

People call it the Price of Power, they call it the Law of Equivalent Exchange, wands, relics, amulets, cantrips, hexes, familiars - one thing is clear - Everything has its price and if you can pay it, you too can become the next 

Arch Mixorcerer

Features Planned

1. Spell Crafting- No cooldowns, only increasing costs (Done)
2. Tons of Spells- starting with elemental and movement, later units etc 
3. Modifiable Terrain that affects combat (Done)
4. Precast Spells at a higher cost, triggered during the opponent turn (Grimoires) (Done)
5. Day(effects)/Night(dmg), power modifiers to bait and juke
6. Replay system (in-game and standalone)
7. LAN Multiplayer and Ladder
8. Mocking Board for pre-calculating

This project is rather ambitious for a person of my skill, so please be patient.
I would be very grateful if any security-related issues were brought to my attention
-kryzel

Special thanks to (in no particular order):
Eleven
Lorentz
Hyperi0n
LimitingFactor
Kukiric
Jebalnik
Dark_Matter
and many others from the Solaris and Godot Discord communities

How To Play The Game

Move the Cursor around with WASD or Arrow keys. The cursor can interact with various units,structures etc. When you select a unit by pressing Space, the HUD becomes populated and you can use the menu options. Currently they are only clickable, but eventually they will all be hotkeyed. You can deselect units by pressing Esc

In general most commands will respond to Space and Esc, they are select/confirm and cancel respectively

Movement: On selecting the Move command, a grid will appear. Focusing the cursor onto the space one wants to move within this grid, press Space

Mixing : On selecting mix mode a screen appears with the various orbs etc. Here you can either craft the spells as standalone, or as grimoires. There are only 
two active spell slots in the inventory, the remainder are devoted to grimoires and other durable inventory. To create a spell, simply fill out its recipe using the
element buttons. You can power up the spell with the Magycke orbs. On selecting the dropdown marked None, you can create two types of grimoires On Terrain Change and On Damage. You can set their thresholds within this screen itself. When you are done, press Space to create your spell or grimoire. Grimoires will have the same name as the spell but with a * at the end like so- Spell*
Currently there are only two spells implemented, fireball (Fire Fire Fire) and blink (Fire Water Air)

Casting: On entering cast mode, the inventory now becomes clickable. When the spell is clicked, it will generate a cast grid and pressing space will cast the spell where the cursor is. On casting a grimoire, precast mode is engaged. Here you can edit the thresholds for the grimoire to cast, and you can save the precast location as either absolute or relative, and select the precast location by pressing Space. when the condition of the grimoire is met, it will automatically cast itself, even in the opponents turn, at the given precast location (if you are outside the spell radius in absolute mode, it will not cast). You will be unable to cast if you have nothing in your inventory

With these simple rules out of the way, I hope you will be able to enjoy the current game a little bit, even though it is basically a demo. Please reach out to me for any issues
-kryzel

Common Coding Patter(ns)

1. h before a variable denotes a handle
2. xw is the max x position. yw is the corollary
