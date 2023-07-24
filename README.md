# Abstract
 A modular, open-source, Proof-of-concept roblox projectile system utilizing ParticleEmitters as a graphical visualization
 Scales easily with Roblox's graphic settings.
 

# Getting Started

  Let's get started with a guide on setting up your first weapon with this module

## Initializing serverside
  In order for this module to operate, server-side functionality must be enabled. You can do this by calling `Module:InitServer()` from a server-side `Script` instance.
  ```lua
  Module:InitServer()
  ```
  To configure sounds, particles, and damage values, See `Module:CreateParticleProfile()`

## Setting Up clientside
  First, in order for this module to function as expected, you'll need 2 things.
  1.) A `BasePart` named `BarrelParticle` located within the tool.
    This will be where the graphical effects will originate from, so make sure it's somewhere that looks good.
  2.) A fully initialized `ParticleProfile` instance

  ### Word of note
    Do note that this module *does not* handle attachment systems for `BasePart`-like instances (Welds,  Attatchments, etc)

  We can initialize our tool by using the `:initClient()` method.
  `ParticleProfile` instances are all based off of a default instance- "Bullet" we can use that to initialize our gun with minimal setup.
  In a LocalScript,
  ```lua
  GunHandler:initClient("Bullet", game.Players.LocalPlayer.Backpack:WaitForChild("ExampleGunLocation"))
  ```lua
  

  
# API Reference

## Instances

`Object:` SettingsObject
An object further detailing the global behavior of a tool
<details>
<summary> Information </summary>

## Properties
<details>

  `String:` Tool
   The `Tool` or `HopperBin` being used with this SettingsObject

  `Bool:` Auto
    Whether or not the tool requires additional mouseclicks to fire consecutively

  `Number:` MaxAmmo
     The max amount of shots before the user must "reload"

  `Number:` Ammo
    The amount of ammo currently in the clip/magazine, usually set the same as MaxAmmo
  
  `Number:` Stored
    The pool of ammo the weapon "reloads" from. When reloading, `MaxAmmo` is subtracted from `Stored`, and `Ammo` is set to `MaxAmmo`
  
  `Number:` FireRate
    The amound of time in seconds after firing until the tool can be fired again
  
  `Number:` Spread
    Hidden. Indicates the probabilic accuracy of the tool. Increases by `BulletSpread` every time the tool is fired, and returns to 0 after `CoolDown` seconds

  `Number:` CoolDown
    The amount of time in seconds after firing where `Spread` returns to the minimum value

  `Number:` MaxSpread
    The maximum value `Spread` can reach
  
  `Number:` Burst
    The number of projectiles per click.
  
  `Number:` BulletSpread
    The amount `Spread` increases by each time the tool is fired
  
  `Bool:` Shotgun
    Whether to operate in a shotgun-like fashion. `Burst` indicates how many projectiles to use per shot.

  `String:` Particle
    The name of the `ParticleProfile` instance ued with the tool.

  `Number:` Recoil
    How intense the camera recoil effect is. Setting this to 0 will disable the camera recoil effect.

  `String:` ReticleImage
    A string in the format of an [Asset Link](https://create.roblox.com/docs/projects/assets) which would be the image of the UI reticle

  `Number:`LastFIred
    A number in the format of Lua's [os.clock](https://create.roblox.com/docs/reference/engine/libraries/os#clock) indicating the last time the tool was fired.

  `Object:` Animations
    An object describing the animations that will play when a specific action is done.
    <details>
    <summary> Information </summary>
      `String:` Equip
        A string in the format of an [Asset Link](https://create.roblox.com/docs/projects/assets) which would be an animation that would play while the weapon is equipped.
      `String:` Fire
        A string in the format of an [Asset Link](https://create.roblox.com/docs/projects/assets) which would be an animation that would play when the weapon is fired. 
      `String:` Reload
        A string in the format of an [Asset Link](https://create.roblox.com/docs/projects/assets) which would be an animation that would play when the weapon is reloaded. 
    </details>

</details>


`Object:` ParticleProfile
An object describing each graphical facet of a projectile
<details>
<summary> Information </summary>

## Properties

<details>

`Object:` PrimaryParticle
This property describes the "projectile" which would be "fired" from the tool. This object has properties analogous to Roblox's [ParticleEmitter](https://create.roblox.com/docs/reference/engine/classes/ParticleEmitter)

`Object:` SecondaryParticle
This property describes the "muzzle flash" which would be centered around the barrel of the tool. This object has properties analogous to Roblox's [ParticleEmitter](https://create.roblox.com/docs/reference/engine/classes/ParticleEmitter)

`Object:` PointLight
This property describes the PointLight which would flash when the tool is "fired".  This object has properties analogous to Roblox's [PointLight](https://create.roblox.com/docs/reference/engine/classes/PointLight)

`SettingsObject:` LocalSettings
This property contains a `SettingsObject` instance, which dictates multiple aspects of the weapon using the ParticleProfile Instance

`Number:` Damage
How much damage each particle does to players

`Object:` Sound
 This property defines what sounds will play when using this particle.
 <details>
  <summary>Properties</summary>

  `Table:` ricochet
    A `String` table of roblox [Asset Links](https://create.roblox.com/docs/projects/assets) listing sounds that will play when a particle hits a non-player object
  
  `Table:` impact
    A `String` table of roblox [Asset Links](https://create.roblox.com/docs/projects/assets) listing sounds that will play when a particle hits a player object

  `String:` fire
    A roblox [Asset Link](https://create.roblox.com/docs/projects/assets) of a sound that will play when a tool utilizing this particle "fires"

  `String:` reload
    A roblox [Asset Link](https://create.roblox.com/docs/projects/assets) of a sound that will play when a tool utilizing this particle "reloads"
    </details>

  `String:`LocalSettings
   a SettingsObject describing additional behavior for the tool using this ParticleObject
</details>

</details>


## Methods
<details>

  

  `ParticleProfile:` CreateParticleProfile(`String:` name)
    Returns a new ParticleProfile instance

  `void:` InitServer()
    Initializes the server listener.
    Must be called from a `Script` instance for this module to function.

  `void:` initClient(`String:` Particle, `Variant`: Tool)
   Initializes the client, using the ParticleProfile instance named `Particle` and using the `Tool` or `HopperBin` instance `Tool`

</details>













 
