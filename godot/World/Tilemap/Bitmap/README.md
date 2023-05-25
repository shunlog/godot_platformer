# World bitmap

The goal is to generate a bitmap of the ground as a Texture,
using combined OpenSimplexNoise nodes.
Currently, this is done in a very hardcoded manner.
For example, the texture for caves consists of 3 noises and 1 Gradient,
and it blends them using a shader,
with each of the four textures as a shader uniform set via a script.
