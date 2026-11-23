from PIL import Image
import OpenEXR
import numpy as np
import Imath
import math

hills = Image.open("the_hills.tif")

TILE_W=512
TILE_H=TILE_W

COLS = math.ceil(hills.width/TILE_W)
ROWS = math.ceil(hills.height/TILE_H)

# print(hills.getextrema())

def save_exr(img:Image, name:str):
    header = OpenEXR.Header(img.width, img.height)
    header["channels"] = {"GRAY":Imath.Channel(Imath.PixelType(Imath.PixelType.FLOAT), 1, 1)}
    exr_out=OpenEXR.OutputFile(name, header)
    exr_out.writePixels({"GRAY": np.array(img).astype(np.float32)})
    exr_out.close()


print()
print(f"Width:       {hills.width:5}")
print(f"Height:      {hills.height:5}")
print(f"Tile width:  {TILE_W:5}")
print(f"Tile height: {TILE_H:5}")
print()
print(f"X tiles: {COLS}")
print(f"Y tiles: {ROWS}")
# the last {columns,rows} will only have X {rows,columns} filled in
print(f"X remainder: {hills.width%TILE_W}")
print(f"Y remainder: {hills.height%TILE_H}")


def possible_tile_sizes():
    print()
    print("possible tile widths:")
    for i in range(1,hills.width):
        if hills.width%i == 0:
            print(f"w={i} tiles={hills.width/i}")
    print()
    print("possible tile heights:")
    for i in range(1,hills.height):
        if hills.height%i == 0:
            print(f"h={i} tiles={hills.height/i}")

for row in range(ROWS):
    for col in range(COLS):
        # print(f"{row=} {col=}")
        cropped = hills.crop((col*TILE_W, row*TILE_H, (col+1)*TILE_W, (row+1)*TILE_H))
        save_exr(cropped,f"exr_tiles/{col:02}_{row:02}.exr")

