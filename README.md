# Abstract
 A modular, open-source, Proof-of-concept roblox projectile system utilizing ParticleEmitters to visualize the projectile. 
 Scales easily with Roblox's graphical settings.
 
# Installation
 1. Open model located in /rbx with Roblox Studio
 2. Place objects withim the folders into appropriately named locations according to the name of the folder they were in

# Use
Using this module only requires a couple things:
1. 2 Sound instances, "Fire" and "Reload" located directly under the tool. These sounds will be played respectively when it is "fired" and "reloaded"
2. A single script instance to reference the main module
3. A copy of the "BarrelParticle" BasePart instance located under Assets/FX. Place this somewhere on your weapon where you want the muzzle and bullet particle effects to emit from
4. Listing weapon damage values under ServerScriptService/GunsHandler, if this is not done, a default damage value will be used.
 - Damage values are stored in an Dictionary-like array named `damagetable` located on line 1. Refer to the example listing for a reference on how to properly input into it.
5. 3 Animation instances, named appropriately under Assets/Animations. Your weapon will have an animation for:
 - Equipping, named "Equip[name of your weapon]"
 - Firing, named "[name of your weapon]Fire"
 - Reloading, named "[name of your weapon]Reload"
6. A BasePart within your tool named specifically "Handle". This is the basis for which the weapon will be oriented.
 Please refer to the module reference as well as the example tool located under StarterPack and Assets/Tools for further information

# Instances
*Variant* `initGun(*Object* parent, *String* guntype, *Bool* auto, *Number* maxammo, *Number* Ammo, *Number* stored, *Int* firerate, *Int* cooldown, *Bool* burst, *Variant* bulletspread, *Bool* shotgun)`
Initializes and runs the tool, runs on instantiation. Called by `require(game.ReplicatedStorage.Assets.Modules.GunHandlerModule)`
- `parent`: should be a Tool Instance
- `guntype`: This is used for referencing animations and damage values. This is usually the name of the weapon as defined under Use (Step 4 and 5). But you can set it to anything to set up a single animation and single damage values for multiple tools.
- `auto`: This should be either `true` or `false`. Configures whether the tool fires in "full auto" or "single fire"
- `maxammo`: Should be a whole number. the max amount of shots before the user must "reload"
- `ammo`: Should be a whole number. the amount of ammo in the clip/magazine when it is equipped, usually set the same as `maxammo`
- `stored`: Should be a whole number. The amount of ammo the weapon comes with in total. (use math.large for infinite)
- `firerate`: Should be a non-zero positive integer. How fast the tool can be "fired"
- `cooldown`: Should be a non-zero positive integer. The amount of time after shots before the bullet spread returns to 0
- `bulletspread`: Optional. Should be `math.random()` with a number range. See Lua's API reference for details on `math.random`. Defaults to `math.random(1,2)` if left `nil`.
- `shotgun`: Optional, defaults to `false`. Determines whether or not to operate in a "scatter gun" like fashion (multiple particles)

 
