# Abstract
 A modular, open-source, Proof-of-concept roblox projectile system utilizing ParticleEmitters to visualize the projectile. 
 Scales easily with Roblox's graphical settings.
 
# Installation
 1. Open model located in /rbx with Roblox Studio
 2. Place the main folder named "Keep in ServerScriptService" in ServerScriptService. It will automatically insert the needed objects into their respective places

# Use

# Creating custom tools
Creating custom tools with this module only requires a couple things:
1. 2 Sound instances, "Fire" and "Reload" located directly under the tool. These sounds will be played respectively when it is "fired" and "reloaded"
2. A single script instance to reference the main module
3. A copy of the "BarrelParticle" BasePart instance located under Assets/FX. Place this somewhere on your weapon where you want the muzzle and bullet particle effects to emit from
4. Listing weapon damage values under Data.ServerScriptService.GunsHandler, if this is not done, a default damage value will be used.
 - Damage values are stored in an Dictionary-like array named `damagetable` located on line 1. Refer to the example listing for a reference on how to properly input into it.
5. 3 Animation instances, named appropriately under Data.ServerScriptService.Assets.Animations. Your weapon will have an animation for:
 - Equipping, named "Equip[name of your weapon]"
 - Firing, named "[name of your weapon]Fire"
 - Reloading, named "[name of your weapon]Reload"
6. A BasePart within your tool named specifically "Handle". This is the basis for which the weapon will be oriented.

Please refer to the module reference as well as the example tool located under Data.ExampleWeapons for further information
Note: This module does not handle "attachments" or "weld" Roblox objects, so be sure to take care of that yourself if you need to.

# Custom Camera Control
This uses its own camera handler, which uses a third person camera mode which locks the cursor to the center of the screen. You can disable this camera control by disabling `CameraHandler` located in Data.StarterPlayer.StarterCharacterScripts.

Note: This also disables camera recoil effects. To utilize your own, there is a way to do so located under Data.StarterPlayer.StarterCharacterScripts.LocalFX:
- `CamRecoil`: A CFrameValue Instance which will change its value according to recoil values from the main module. You can use this information for your own camera uses as rotation values.
- `CamShake`: A Vector3Value Instance which will change its value according to shake values from the main module. You can use this information for your own camera uses to shake the camera.
- `Recoil`: A BoolValue Instance indicating whether the camera should be experiencing recoil
- `Shaking`:A BoolValue Instance indicating whether the camera should be experiencing shake

# Killfeed
When a player inflicts damage on another player, an ObjectValue Instance named "creator" is placed in the damaged player's Humanoid, with the value referencing the character who caused the damage. This can be used as assistance in keeping track of player damages.


# Instances
*Variant* `initGun(*Object* parent, *String* guntype, *Bool* auto, *Number* maxammo, *Number* Ammo, *Number* stored, *Int* firerate, *Int* cooldown, *Number* burst, *Variant* bulletspread, *Bool* shotgun)`
Initializes and runs the tool, runs on instantiation. Returned by `require(game.ReplicatedStorage.Assets.Modules.GunHandlerModule)`
Note: `game.ReplicatedStorage.Assets.Modules.GunHandlerModule`is the location `GunHandlerModule` will always be on server start. It's wise to wait for it to unpack there before referencing it. 
- `parent`: should be a Tool Instance
- `guntype`: This is used for referencing animations and damage values. This is usually the name of the weapon as defined under Use (Step 4 and 5). But you can set it to anything to set up a single animation and single damage values for multiple tools.
- `auto`: This should be either `true` or `false`. Configures whether the tool fires in "full auto" or "single fire"
- `maxammo`: Should be a whole number. the max amount of shots before the user must "reload"
- `ammo`: Should be a whole number. the amount of ammo in the clip/magazine when it is equipped, usually set the same as `maxammo`
- `stored`: Should be a whole number. The amount of ammo the weapon comes with in total. (use math.large for infinite)
- `firerate`: Should be a non-zero positive integer. How fast the tool can be "fired"
- `cooldown`: Should be a non-zero positive integer. The amount of time after shots before the bullet spread returns to 0
- `burst`: Should be a non-zero positive whole number. This number dictates how many projectiles to fire per "click". In "shotgun" applications, this dictates how many projectiles in the slug.
- `bulletspread`: Optional. Dictates how accurate the weapon is over consecuive shots. Should be `math.random()` with a number range. See Lua's API reference for details on `math.random`. Defaults to `math.random(1,2)` if left `nil`.
- `shotgun`: Optional, defaults to `false`. Determines whether or not to operate in a "scatter gun" like fashion.

 
