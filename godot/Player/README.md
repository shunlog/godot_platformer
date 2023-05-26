# Player

The Player scene was taken from this [demo](https://godotengine.org/asset-library/asset/1637), as it is very advanced and works very well.
However, I don't quite like the =Player.gd= script.
I'll treat it as a black box for now.

I don't think it could happen that the `Player` exists without the tilemaps,
but just to make it standalone, I still check whether the tilemaps are not null before using them (for example when mining).
