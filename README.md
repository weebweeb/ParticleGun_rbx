# Abstract
 A modular, open-source, Proof-of-concept roblox projectile system utilizing ParticleEmitters as a graphical visualization. 
 <p> Scales easily with Roblox's graphic settings.</p>
 
This module uses Roblox's <a href="https://create.roblox.com/docs/reference/engine/classes/ParticleEmitter">ParticleEmitter</a> instance to simulate a projectile moving through the air, while the damage calculations are done with a <a href="https://create.roblox.com/docs/reference/engine/datatypes/Ray">Ray</a>. This is both a simple and efficient way to simulate projectiles in the game engine. However, LOD and performance options are out of our control, managed by the game engine internals. This means at lower graphic quality levels, some or all projectiles may not be visible. 

![RobloxStudioBeta_qObwz0E0Ab](https://github.com/weebweeb/ParticleGun_rbx/assets/20445961/58225757-f0ee-479b-ab7c-3927336ffa8d)

 
By allowing ParticleEmitters to emit at a certain rate, we can generate single "particle" images, which move toward our designated target at our specified velocity and rate.

# Installation

## Wally
If you're using Wally, include
```
ParticleGun = "weebweeb/particlegun@^0.4"
```
under your dependencies in your project's `wally.toml`

## Manually
You can also download the recent release <a href = "https://github.com/weebweeb/ParticleGun_rbx/releases/tag/Release">here</a>. 
Open the `rbxm` file in Roblox Studio and place the ModuleScript wherever is most convenient for your workflow, or download the source to use wherever else you might want it.

# Usage

<details>
 
<summary>Setting up a basic weapon</summary>
 
  Let's get started with a guide on setting up a basic weapon with this module

## Initializing serverside
  <p>In order for this module to operate, server-side functionality must be enabled. </p>
  
  You can do this by calling <a href= "https://github.com/weebweeb/ParticleGun_rbx#void-initserver">InitServer() </a> from a <a href= "https://create.roblox.com/docs/reference/engine/classes/Script">Script</a> instance.
  
  ```lua
  Module:InitServer()
  ```
  <p>To configure sounds, particles, and damage values, See <a href = "https://github.com/weebweeb/ParticleGun_rbx#particleprofile-createparticleprofilestring-name">CreateParticleProfile()</a> </p>

## Setting Up clientside
<p> First, in order for this module to function as expected, you'll need 3 things.</p>

   1.) A <a href = "https://create.roblox.com/docs/reference/engine/classes/BasePart">BasePart</a> named `BarrelParticle` located within the Tool.
   
   <p>This will be where the graphical effects will originate from, so make sure it's somewhere that looks good.</p>
   
  2.) A fully initialized <a href = "https://github.com/weebweeb/ParticleGun_rbx#object-particleprofile">ParticleProfile</a> instance

  3.) A <a href = "https://create.roblox.com/docs/reference/engine/classes/BasePart">BasePart</a> named `Handle` located within the Tool.
      <p>This will where the player will hold the tool, so make sure it's somewhere that makes sense.</p>


  ### Word of note
   Do note that this module *does not* handle attachment systems for <a href="https://create.roblox.com/docs/reference/engine/classes/BasePart">BasePart</a>-like instances (<a href="https://create.roblox.com/docs/reference/engine/classes/Weld">Welds</a>,  <a href="https://create.roblox.com/docs/reference/engine/classes/Attachment">Attatchments</a>, etc)

  <p>We can initialize client-side by using the <a href = "https://github.com/weebweeb/ParticleGun_rbx#void-initclientstring-particle-variant-tool">initClient()</a> method.</p>
  <p> ParticleProfile instances are all based off of a default instance- "Bullet" we can use that to initialize our gun with minimal setup.</p>
  
  ```lua
   --In a LocalScript,
  Module:initClient("Bullet", game.Players.LocalPlayer.Backpack:WaitForChild("ExampleGunLocation"))
  ```
  This will initialize our tool located at `game.Players.LocalPlayer.Backpack:WaitForChild("ExampleGunLocation")` with the default ParticleProfile object.
  
</details>

<details>
 <summary>Creating a new custom weapon</summary>
<p>In order to create new tools and particle effects, we must first create a new ParticleProfile instance.</p>
We can instantiate a new ParticleProfile instance by calling <a href = "https://github.com/weebweeb/ParticleGun_rbx#particleprofile-createparticleprofilestring-name">CreateParticleProfile()</a> from a server-sided script.

<p>Let's create a new ParticleProfile instance called "Test"</p>

```lua
local TestParticle = Module:CreateParticleProfile("Test")
```
<p>This both returns to us our new ParticleProfile instance, and adds itself to an internal database, to be referenced by its name- "Test"</p>
<p>ParticleProfile instances contain many variables and settings used to control the behavior and appearance of both the weapon firing it as well as the projectile.</p>
<p>Let's go ahead and change how the particle behaves.</p>
<p>
Our particle appearance has 3 components:</p>
<ul>
 <li>PrimaryParticle - This is the ParticleEmitter that acts as the "projectile"</li>
<li>SecondaryParticle - This is the ParticleEmitter that promotes a "muzzle flash"-like effect</li>
<li>PointLight - This instance is a PointLight which generates light when the weapon is fired</li>
</ul>

<p>Let's go ahead and change our PrimaryParticle's Texture.</p>

```lua
AutoParticle.PrimaryParticle.Texture = "rbxassetid://1266170131"
```

and that's it! These appearance options were put together to maximize utility and ease of use, so feel free to check out the documentation in this document.

</details>

  

## Instances

#### `Object:` SettingsObject
<p> An object further detailing the global behavior of a tool </p>
<details>
<summary>Properties</summary>
 
  `String:` Tool
   <p>The <a href= "https://create.roblox.com/docs/reference/engine/classes/Tool">Tool</a> or <a href= "https://create.roblox.com/docs/reference/engine/classes/HopperBin">HopperBin</a> being used with this SettingsObject</p>

  `Bool:` Auto
    <p>Whether or not the tool requires additional mouseclicks to fire consecutively. Default is `false`</p>

  `Number:` MaxAmmo
     <p>The max amount of shots before the user must "reload". Default is `20`</p>

  `Number:` Ammo
    <p>The amount of ammo currently in the clip/magazine, usually set the same as MaxAmmo. Default is `20`</p>
  
  `Number:` Stored
    <p>The pool of ammo the weapon "reloads" from. When reloading, `MaxAmmo` is subtracted from `Stored`, and `Ammo` is set to `MaxAmmo`. Default is <a href ="https://create.roblox.com/docs/reference/engine/libraries/math#huge">math.huge</a> </p>
  
  `Number:` FireRate
   <p> The amound of time in seconds after firing until the tool can be fired again. Default is <code>0.15</code> </p>
  
  `Number:` Spread
   <p> Hidden. Indicates the probabilic accuracy of the tool. Increases by <code>BulletSpread</code> every time the tool is fired, and returns to 0 after <code>CoolDown</code> seconds</p>

  `Number:` CoolDown
    <p>The amount of time in seconds after firing where `Spread` returns to the minimum value. Default is `1`  </p>

  `Number:` MaxSpread
   <p> The maximum value <code>Spread</code> can reach. Default is <code>50</code></p>
  
  `Number:` Burst
   <p> The number of projectiles per click. Default is <code>1</code> </p>
  
  `Number:` BulletSpread
    <p>The amount `Spread` increases by each time the tool is fired. Default is <a href="https://create.roblox.com/docs/reference/engine/libraries/math#random">math.random</a>(1,3) </p>
  
  `Bool:` Shotgun
   <p> Whether to operate in a shotgun-like fashion. <code>Burst</code> indicates how many projectiles to use per shot. Default is <code>false</code> </p>

  `String:` Particle
    <p>The name of the `ParticleProfile` instance ued with the tool.</p>

  `Number:` Recoil
    <p>How intense the camera recoil effect is. Setting this to 0 will disable the camera recoil effect. Default is `1.5` </p>

  `Number:` Distance
    <p>The distance in <a href="https://create.roblox.com/docs/physics/units">Studs</a> that the weapon can damage players. Default is <code>2000</code> </p>

  `String:` ReticleImage
    <p>A string in the format of an <a href= "https://create.roblox.com/docs/projects/assets">Asset Link</a> which would be the image of the UI reticle</p>

  `Number:`LastFIred
   <p> A number in the format of Lua's <a href = "https://create.roblox.com/docs/reference/engine/libraries/os#clock">os.clock</a> indicating the last time the tool was fired.</p>

  `Object:` Animations
    <p> An object describing the animations that will play when a specific action is done. </p>
    <details>
    <summary> Properties </summary>
      `String:` Equip
       <p> A string in the format of an <a href= "https://create.roblox.com/docs/projects/assets">Asset Link</a> which would be an animation that would play while the weapon is equipped.</p>
      `String:` Fire
       <p> A string in the format of an <a href= "https://create.roblox.com/docs/projects/assets">Asset Link</a> which would be an animation that would play when the weapon is fired. </p>
      `String:` Reload
        <p>A string in the format of an <a href= "https://create.roblox.com/docs/projects/assets">Asset Link</a> which would be an animation that would play when the weapon is reloaded. </p>

</details>
</details>


#### `Object:` ParticleProfile
<p> An object describing each graphical facet of a projectile </p>

<details>
<summary> Properties </summary>

`ParticleEmitter:` PrimaryParticle
<p>This property describes the ParticleEmitter image which would be "fired" from the tool. This object has properties analogous to Roblox's <a href = "https://create.roblox.com/docs/reference/engine/classes/ParticleEmitter">ParticleEmitter</a> instance</p>

`ParticleEmitter:` SecondaryParticle
<p> This property describes the "muzzle flash" which would be centered around the barrel of the tool. This object has properties analogous to Roblox's <a href = "https://create.roblox.com/docs/reference/engine/classes/ParticleEmitter">ParticleEmitter</a> instance</p>

`PointLight:` PointLight
<p>This property describes the PointLight which would enable when the tool is "fired".  This object has properties analogous to Roblox's <a href = "https://create.roblox.com/docs/reference/engine/classes/PointLight">PointLight</a> instance</p>

`SettingsObject:` LocalSettings
<p>This property contains a <a href="https://github.com/weebweeb/ParticleGun_rbx#object-settingsobject">SettingsObject</a> instance, which dictates multiple aspects of the weapon using the ParticleProfile Instance</p>

`Number:` Damage
<p>How much damage each particle does to players</p>

`Table:` Sound
 <p>This property defines what sounds will play when using this particle.</p>
 <details>
  <summary>Properties</summary>

  `Table:` ricochet
    <p> A `String` table of roblox <a href= "https://create.roblox.com/docs/projects/assets">Asset Links</a> listing sounds that will play when a particle hits a non-player object</p>
  
  `Table:` impact
   <p> A <code>String</code> table of roblox <a href= "https://create.roblox.com/docs/projects/assets">Asset Links</a> listing sounds that will play when a particle hits a player object</p>

  `String:` fire
    <p> A roblox <a href= "https://create.roblox.com/docs/projects/assets">Asset Link</a> of a sound that will play when a tool utilizing this particle "fires" </p>

  `String:` reload
    <p>A roblox <a href= "https://create.roblox.com/docs/projects/assets">Asset Link</a> of a sound that will play when a tool utilizing this particle "reloads"</p>
    </details>

  `SettingsObject:` LocalSettings
   <p> a <a href = "https://github.com/weebweeb/ParticleGun_rbx#object-settingsobject">SettingsObject</a> describing additional behavior for the tool using this ParticleObject </p>

</details>


## Methods

  

 #### `ParticleProfile:` CreateParticleProfile(`String:` name)
  Returns a new <a href ="https://github.com/weebweeb/ParticleGun_rbx#object-particleprofile">ParticleProfile</a> instance

####  `void:` InitServer()
    
<p> Initializes the server listener.
    Must be called from a <a href = "https://create.roblox.com/docs/reference/engine/classes/Script">Script</a> for this module to function. </p>

 #### `void:` initClient(`String:` Particle, `Variant`: Tool)

   Initializes the client, using the <a href= "https://github.com/weebweeb/ParticleGun_rbx#object-particleprofile">ParticleProfile</a> instance named `Particle` and using the <a href="https://create.roblox.com/docs/reference/engine/classes/Tool">Tool</a> or <a href="https://create.roblox.com/docs/reference/engine/classes/HopperBin">HopperBin</a> instance `Tool`













 
