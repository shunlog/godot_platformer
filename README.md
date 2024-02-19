I tried creating a Terraria-like platformer in Godot 4.1.
It turned out to be harder than I thought, and I abandoned it.
I would recommend using a game library rather than a game engine like Godot for something as complex as Terraria, you will need the flexibility.

My main issues were:
- a weird 2D physics bug (https://github.com/godotengine/godot/issues/77571)
- water physics in Godot not straightforward
- tilemap lighting in Godot not straightforward

Developing in Godot 3 was more stable,
and I managed to get simple world generation and breaking blocks,
but then needed to switch to Godot 4 because of a better Tilemap and more noise functionalities.

Additionally, it seems that recreating Terraria without making a mess [is pretty difficult](https://github.com/radian-software/TerrariaClone).
