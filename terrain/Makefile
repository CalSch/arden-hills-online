
sota.vrt:
	curl https://g46prsaddst01.blob.core.windows.net/mntopo/dem_100k/2nd_Generation_Seamless_Lidar_DEM.vrt > sota.vrt

the_hills.tif: sota.vrt
	gdal_translate -projwin -93.188241 45.108074 -93.146983 45.035727 -projwin_srs EPSG:4326 sota.vrt the_hills.tif

arden_hills_color.tif: ah_color.sh
	bash ah_color.sh

exr_tiles the_hills.exr: the_hills.tif split.py
	mkdir -vp exr_tiles
	python3 split.py

clean:
	rm -rvf tiles/ exr_tiles/ arden_hills_color.tif the_hills.tif sota.vrt

.PHONY: clean
