import math

# 6371.008*2*pi*(45.108074-45.035727)/360
EARTH_RADIUS_EQ=6_378_137.0
EARTH_RADIUS_PO=6_356_752.3
EARTH_RADIUS=6_371_008.8
PI=3.14159265358979323
DEG2RAD=PI/180

# -93.188241 45.108074 -93.146983 45.035727
LAT_MAX = 45.108074
LAT_MIN = 45.035727

LON_MAX = -93.146983
LON_MIN = -93.188241

AH_WIDTH = (LON_MAX-LON_MIN) / 360 * EARTH_RADIUS*math.cos(LAT_MIN*DEG2RAD) * 2 * PI
AH_HEIGHT = (LAT_MAX-LAT_MIN) / 360 * EARTH_RADIUS * 2 * PI

# heightmap resolution
HM_W =  6530
HM_H = 16088

print("--- arden hills ---")
print(f"width:  {LON_MAX-LON_MIN:.5f}° = {AH_WIDTH:.2f} m")
print(f"height: {LAT_MAX-LAT_MIN:.5f}° = {AH_HEIGHT:.2f} m")
print(f"aspect: 1:{AH_HEIGHT/AH_WIDTH:.5}")
print()
print("--- height map image ---")
print(f"X resolution: {AH_WIDTH/HM_W:1.4f} m/pix")
print(f"Y resolution: {AH_HEIGHT/HM_H:1.4f} m/pix")
print(f"aspect: 1:{HM_H/HM_W:.5}")
