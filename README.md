# Abstract
 A modular, open-source, Proof-of-concept roblox projectile system utilizing ParticleEmitters as a graphical visualization
 Scales easily with Roblox's graphic settings.
 

# Getting Started

  Let's get started with a guide on setting up your first weapon with this module

## Initializing serverside
  <p>In order for this module to operate, server-side functionality must be enabled. </p>
  
  You can do this by calling `Module:InitServer()` from a server-side `Script` instance.
  
  ```lua
  Module:InitServer()
  ```
  <p>To configure sounds, particles, and damage values, See `Module:CreateParticleProfile()`</p>

## Setting Up clientside
<p> First, in order for this module to function as expected, you'll need 2 things.</p>

   1.) A `BasePart` named `BarrelParticle` located within the tool.
   
   <p>This will be where the graphical effects will originate from, so make sure it's somewhere that looks good.</p>
   
  2.) A fully initialized `ParticleProfile` instance

  ### Word of note
   Do note that this module *does not* handle attachment systems for `BasePart`-like instances (Welds,  Attatchments, etc)

  <p>We can initialize our tool by using the `:initClient()` method.</p>
  <p> ParticleProfile instances are all based off of a default instance- "Bullet" we can use that to initialize our gun with minimal setup.</p>
  
  ```lua
   --In a LocalScript,
  GunHandler:initClient("Bullet", game.Players.LocalPlayer.Backpack:WaitForChild("ExampleGunLocation"))
  ```
  

  

## Instances

#### `Object:` SettingsObject
<p> An object further detailing the global behavior of a tool </p>
<details>
<summary>Properties</summary>
 
  `String:` Tool
   <p>The `Tool` or `HopperBin` being used with this SettingsObject</p>

  `Bool:` Auto
    <p>Whether or not the tool requires additional mouseclicks to fire consecutively</p>

  `Number:` MaxAmmo
     <p>The max amount of shots before the user must "reload"</p>

  `Number:` Ammo
    <p>The amount of ammo currently in the clip/magazine, usually set the same as MaxAmmo</p>
  
  `Number:` Stored
    <p>The pool of ammo the weapon "reloads" from. When reloading, `MaxAmmo` is subtracted from `Stored`, and `Ammo` is set to `MaxAmmo`</p>
  
  `Number:` FireRate
   <p> The amound of time in seconds after firing until the tool can be fired again</p>
  
  `Number:` Spread
   <p> Hidden. Indicates the probabilic accuracy of the tool. Increases by `BulletSpread` every time the tool is fired, and returns to 0 after `CoolDown` seconds</p>

  `Number:` CoolDown
    <p>The amount of time in seconds after firing where `Spread` returns to the minimum value</p>

  `Number:` MaxSpread
   <p> The maximum value `Spread` can reach</p>
  
  `Number:` Burst
   <p> The number of projectiles per click.</p>
  
  `Number:` BulletSpread
    <p>The amount `Spread` increases by each time the tool is fired</p>
  
  `Bool:` Shotgun
   <p> Whether to operate in a shotgun-like fashion. `Burst` indicates how many projectiles to use per shot.</p>

  `String:` Particle
    <p>The name of the `ParticleProfile` instance ued with the tool.</p>

  `Number:` Recoil
    <p>How intense the camera recoil effect is. Setting this to 0 will disable the camera recoil effect.</p>

  `String:` ReticleImage
    <p>A string in the format of an [Asset Link](https://create.roblox.com/docs/projects/assets) which would be the image of the UI reticle</p>

  `Number:`LastFIred
   <p> A number in the format of Lua's [os.clock](https://create.roblox.com/docs/reference/engine/libraries/os#clock) indicating the last time the tool was fired.</p>

  `Object:` Animations
    <p> An object describing the animations that will play when a specific action is done. </p>
    <details>
    <summary> Properties </summary>
      `String:` Equip
       <p> A string in the format of an [Asset Link](https://create.roblox.com/docs/projects/assets) which would be an animation that would play while the weapon is equipped.</p>
      `String:` Fire
       <p> A string in the format of an [Asset Link](https://create.roblox.com/docs/projects/assets) which would be an animation that would play when the weapon is fired. </p>
      `String:` Reload
        <p>A string in the format of an [Asset Link](https://create.roblox.com/docs/projects/assets) which would be an animation that would play when the weapon is reloaded. </p>

</details>
</details>


#### `Object:` ParticleProfile
<p> An object describing each graphical facet of a projectile </p>

<details>
<summary> Properties </summary>

`Object:` PrimaryParticle
<p>This property describes the "projectile" which would be "fired" from the tool. This object has properties analogous to Roblox's [ParticleEmitter](https://create.roblox.com/docs/reference/engine/classes/ParticleEmitter)</p>

`Object:` SecondaryParticle
<p> This property describes the "muzzle flash" which would be centered around the barrel of the tool. This object has properties analogous to Roblox's [ParticleEmitter](https://create.roblox.com/docs/reference/engine/classes/ParticleEmitter)</p>

`Object:` PointLight
<p>This property describes the PointLight which would flash when the tool is "fired".  This object has properties analogous to Roblox's [PointLight](https://create.roblox.com/docs/reference/engine/classes/PointLight) </p>

`SettingsObject:` LocalSettings
<p>This property contains a `SettingsObject` instance, which dictates multiple aspects of the weapon using the ParticleProfile Instance</p>

`Number:` Damage
<p>How much damage each particle does to players</p>

`Object:` Sound
 <p>This property defines what sounds will play when using this particle.</p>
 <details>
  <summary>Properties</summary>

  `Table:` ricochet
    <p> A `String` table of roblox [Asset Links](https://create.roblox.com/docs/projects/assets) listing sounds that will play when a particle hits a non-player object</p>
  
  `Table:` impact
   <p> A `String` table of roblox [Asset Links](https://create.roblox.com/docs/projects/assets) listing sounds that will play when a particle hits a player object</p>

  `String:` fire
    <p> A roblox [Asset Link](https://create.roblox.com/docs/projects/assets) of a sound that will play when a tool utilizing this particle "fires" </p>

  `String:` reload
    <p>A roblox [Asset Link](https://create.roblox.com/docs/projects/assets) of a sound that will play when a tool utilizing this particle "reloads"</p>
    </details>

  `String:`LocalSettings
   <p> a SettingsObject describing additional behavior for the tool using this ParticleObject </p>

</details>


## Methods

  

 #### `ParticleProfile:` CreateParticleProfile(`String:` name)
  Returns a new ParticleProfile instance

####  `void:` InitServer()
    
<p> Initializes the server listener.
    Must be called from a Script for this module to function. </p>

 #### `void:` initClient(`String:` Particle, `Variant`: Tool)

   Initializes the client, using the ParticleProfile instance named `Particle` and using the `Tool` or `HopperBin` instance `Tool`













 
