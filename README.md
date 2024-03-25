# Survival-Game

|Preview|
|----|
|![Preview](https://media.discordapp.net/attachments/1044495816489967626/1067299314675761232/preview.gif?ex=660b88f2&is=65f913f2&hm=4602afce4cf028485c0d82e075cc3967f4e88c1824b32cc6f7d55e0074a7e480&=)|

Like many others in the CS field who came before me, my interest in game development was the igniting fire that stoked my journey into the world of Computer Science.
As a child, I was always drawn to the idea of being able to create my own little universe and see my dreams come to life on a computer.
Though I have worked on other small games since I was a teenager, this game is the culmination of those efforts to learn to program.

I have been developing this game on and off in my spare time from school since the beginning of 2022, practicing my coding skills in the process of figuring out how to implement ideas and systems that I think would be awesome.
Although to most, this project is not something that would wow them, I have spent countless hours refining my skills as a programmer in the process of making this my dream game. By solving difficult technical and design problems on my own, I have accumulated new problem-solving skills and techniques for writing code that I did not learn in any class from college.

**So, from the perspective of experience and skills gained, this is my most successful project yet.**

Although I am just in the beginning steps of creating a playable game, which requires much more work to go before it's where I would like it to be, it has served my self-learning greatly. For this reason, I decided it would be a great choice to show it off proudly.

# Design of the Core Game Loop:

## Inventory

|Inventory Rearrangement|Item Collection|
|----|----|
|![InventoryRearrange](https://media.discordapp.net/attachments/1044495816489967626/1067293454650064926/inventory-rearrange.gif?ex=660b837c&is=65f90e7c&hm=e6b2d77228f8de59145c2bf254e7ab1d38c35126d85585b706f0de1a9e09e2b1&=)|![ItemCollection](https://media.discordapp.net/attachments/1044495816489967626/1067293439420538930/tree-chopping.gif?ex=660b8379&is=65f90e79&hm=28aef2332d2e5b5b5045cbca7c9deb8028cf0a64590bef7273d187515d06b862&=)

The Inventory system was the first feature I decided to tackle on this project, as designing one I liked was a huge headache for me in the past.
The complexity of designing a system that is responsible for interacting with both GUI elements and with the game states, to represent persistent data, was a difficult challenge for me at the time.

Though, I didn't necessarily want to *reinvent the wheel*, looking into other pre-made solutions online yielded only two implementations that I liked, both unfortunately being written unnecessarily complex and with poor scalability for my future outlooks with the game.
So, by following the base concepts layed out by those examples I studied, I wrote my own system from the ground-up in order to meet my standards.

---

## Recipies & Crafting

|Crafting Menu|
|----|
|![Crafting](https://media.discordapp.net/attachments/1044495816489967626/1067293461897814026/crafting.gif?ex=660b837e&is=65f90e7e&hm=c0557e553d221d890d0453e637cb020f7e71f4bd095cd484aa88631b3cfee288&=)|

One feature that's pretty standard to see in survival games is a crafting menu, as collecting resources and making things from them is a quintessential aspect of progression in this genre.

How to go about it?

I settled on a system for recipe unlocking such that every craftable item in the game has a material that unlocks its recipe.
Once unlocked, an icon for that item shows up on a portion of the screen that is designated for the menu and can be crafted if all components are obtained.
In this process of crafting, the Inventory and Crafting menu objects emit events to each other to communicate what actions should be taken at different steps of the process.

These events include but arent limited to:

- Recipe unlocking
- Item craftability state changes
- Crafting queue and unqueue
- Crafting completion (Item creation and consuming recipe components)

---

## Persistent Data - World and Player Saves

|New Character|Character Creation|Character Deletion|
|----|----|----|
|![CharacterNew](https://cdn.discordapp.com/attachments/1044495816489967626/1067295428476940318/character-new.gif?ex=660b8553&is=65f91053&hm=be842927cac7fb6ab4f64ea662d8370a8018f1de1a6da5d120a4c436502de77e&)|![CharacterCreation](https://media.discordapp.net/attachments/1044495816489967626/1067293407183110255/character-creation.gif?ex=660b8371&is=65f90e71&hm=dbe49b21821b48ae827588997f4fc461928ad707a1b2517674719b7a1a007027&=)|![CharacterDeletion](https://media.discordapp.net/attachments/1044495816489967626/1067293431958876171/character-delete.gif?ex=660b8377&is=65f90e77&hm=c596e9d5b4fc97ae3d601753dc453ad3c76f4d82d6fbee103f8129fefb071d91&=)

In most but not all games, it's necessary to save the user data so that when they quit out, they can pick up the game at a later point and continue where they left off.
This is definitely the case for my game so I looked into a couple possible options for doing so.

- Resource Persistence
- JSON

While resource persistence was a cool, officially-supported Godot implementation for saving well- ...Resources, I already had some small experience with the JSON file format in the past. On top of that, going with JSON would be a more universally applicable option as Resource saving is specific only to the Godot engine.

|Character Select|
|----|
|![CharacterPlay](https://media.discordapp.net/attachments/1044495816489967626/1067293422693650443/character-play.gif?ex=660b8375&is=65f90e75&hm=551adecf8d8f468e31e7971b1144c261b6aeab218c597d9c26c8f08580d2ca9a&=)|

Moving forward with this choice, I have my game create a save directory where both World and Player data are saved, but in separate folders.
When you quit and come back, the menus for selecting your save are dynamically generated with a card for each save existing on your computer.
Creating, deleting, and selecting saves are all done through the use of cards as I could pre-design them and then fill out their contents once the data is read from the save directory.

|Inventory Persistence|
|----|
|![InventoryPersistence](https://media.discordapp.net/attachments/1044495816489967626/1067293446437621760/inventory-persistence.gif?ex=660b837a&is=65f90e7a&hm=5ed021cf57b93bf0b0d731961544111d6a7fb6c07d0a4babef6d1e4b4a556bdf&=)|

---

## World Generation and Noise Maps

|Dense Forest|
|----|
|![DenseForestExploration](https://media.discordapp.net/attachments/1044495816489967626/1067293476275900456/dense-forest-exploration.gif?ex=660b8382&is=65f90e82&hm=8a3fc99e467030c599a0abf24176d352b952ff9ce00e9f6b9edc8adf403040e8&=)|

If done in a way that enhances gameplay and replayability, another great feature of the survival game genre is providing the player with procedurally generated worlds to explore.
Going down this rabbit-hole was an experience that taught me so many clever algorithms and approaches to creating procedural content.

### Poisson-Disc Sampling
    
> When distributing objects in a scene randomly, it is usually ideal to spread them in a way that avoids clumping.
> One such approach is referred to as poisson-disc sampling, which utilizes a gridmap architecture to validate that object placements aren't too close to already existing objects. 

|Object Distribution in 2D Space|
|----|
|![WorldChunkLoading](https://media.discordapp.net/attachments/1044495816489967626/1067308589489868891/193etzinfnl4hznceyotevg.png?ex=660b9195&is=65f91c95&hm=02c86572155f796b812300804c1c5ddd0d2cbc3bbe5e96ad6a3db6595ce89215&=&format=webp&quality=lossless)|

> By building this algorithm on top of a gridmap, you are able to reduce time complexity from O(n^2) to O(1); A huge perfomance savings.
> This is because instead of having to compare the distances between all existing points for a new point, you only have to compare points located in grids in close proximity to the new point.

|Performant Chunk Loading/Unloading|
|----|
|![WorldChunkLoading](https://media.discordapp.net/attachments/1044495816489967626/1067293490339381248/world-chunk-loading.gif?ex=660b8385&is=65f90e85&hm=531e609925078b724557119ecb45386b0ec5555cbf671f16a6fcd096066d89b8&=)|

### OpenSimplex Noise

> Once you have generated random, but fairly even placements of points, you can then utilize a noise map in order to determine what to place and where.
    
> Side note:
> OpenSimplex noise is an open-source algorithm based on Ken Perlin's Perlin noise, which he originally invented back in 1983 whilest working on Disney's Tron film.
> He created these algorithms in order to help him design computer scenery that was random but smooth so that it seemed natural to the eye.

> By filtering your chosen point distribution through the output range of the noise algorithm, you can create a natural-looking landscape that is populated with scenery objects.
> Taking this step further, you can employ multiple different noise maps, referring to different properties such as height, temperature, and moisture, in order to add additional realism and complexity to your world.

These are noise techniques I learned about while reading the blog of Amit Patel, a figure that I look up to for helping develop one of my favorite games. You can read more on his blog here:
https://www.redblobgames.com
