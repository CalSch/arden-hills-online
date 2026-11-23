#!/bin/bash
set -eu

# --- config ---
# LAYER="rams20"
LAYER="fsa2025"
SRS="EPSG:26915"
# RES=0.15          # meters/pixel
RES=0.6          # meters/pixel
TILE_PX=3000      # pixels per side per request (keep conservative)

MINX=485191.6
MAXX=488422.7
MINY=4986929.7
MAXY=4994973.4

OUTDIR="tiles"
mkdir -p "$OUTDIR"

TILE_M=$(echo "$TILE_PX * $RES" | bc)   # tile size in meters

x=$MINX
i=0
while (( $(echo "$x < $MAXX" | bc -l) )); do
  x2=$(echo "$x + $TILE_M" | bc)
  if (( $(echo "$x2 > $MAXX" | bc -l) )); then x2=$MAXX; fi
  y=$MINY
  j=0
  while (( $(echo "$y < $MAXY" | bc -l) )); do
    y2=$(echo "$y + $TILE_M" | bc)
    if (( $(echo "$y2 > $MAXY" | bc -l) )); then y2=$MAXY; fi

    W=$(echo "($x2 - $x)/$RES" | bc | cut -d. -f1)
    H=$(echo "($y2 - $y)/$RES" | bc | cut -d. -f1)

    JPG="$OUTDIR/tile_${i}_${j}.jpg"
    TIF="$OUTDIR/tile_${i}_${j}.tif"

    echo "Fetching tile $i,$j  bbox=$x,$y,$x2,$y2  size=${W}x${H}"
    curl -s -G "https://imageserver.gisdata.mn.gov/cgi-bin/wms" \
      --data-urlencode "SERVICE=WMS" \
      --data-urlencode "VERSION=1.1.1" \
      --data-urlencode "REQUEST=GetMap" \
      --data-urlencode "LAYERS=$LAYER" \
      --data-urlencode "SRS=$SRS" \
      --data-urlencode "BBOX=$x,$y,$x2,$y2" \
      --data-urlencode "WIDTH=$W" \
      --data-urlencode "HEIGHT=$H" \
      --data-urlencode "FORMAT=image/jpeg" \
      -o "$JPG"

    # sanity check: make sure we got an actual image, not an XML error
    filetype=$(file -b "$JPG")
    if [[ "$filetype" != *"JPEG"* ]]; then
      echo "  WARNING: tile $i,$j did not return a JPEG. Response was:"
      head -c 300 "$JPG"
      echo
    else
      # georeference the tile
      gdal_translate -q -a_srs "$SRS" -a_ullr "$x" "$y2" "$x2" "$y" "$JPG" "$TIF"
    fi

    y=$y2
    j=$((j+1))
  done
  x=$x2
  i=$((i+1))
done

echo "Mosaicking..."
gdalbuildvrt "$OUTDIR/mosaic.vrt" "$OUTDIR"/tile_*.tif
gdal_translate "$OUTDIR/mosaic.vrt" arden_hills_color.tif

echo "Done: arden_hills_color.tif"
