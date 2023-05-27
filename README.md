# Terraria clone

Note that the documentation for this game is split into multiple `README.md` files [as close to scenes as possible](https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html#organization).

# Upgrading to Godot 4
I've started this project in Godot 3, but I'm missing many features present in Godot 4:
- Tilemaps can assign data to tiles (e.g. block hardness)
- Can place scenes as tiles (e.g. needed for chests)
- Better noise (necessary for worldgen)

Although there are a few issues with Godot 4:
- export to HTML doesn't quite  work yet
- the Player is falling through blocks for a frame, as if collisions isn't snappy (can't figure out what's the problem)
