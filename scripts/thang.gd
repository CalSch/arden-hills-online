extends Node3D

func _ready() -> void:
	#for child in get_children():
		#remove_child(child)
	for y in 3:
		for x in 3:
			var tile: TerrainTile = preload("res://scenes/terrain_tile.tscn").instantiate()
			add_child(tile)
			tile.position.x = x*TerrainTile.TILE_WIDTH*TerrainTile.H_PPM
			tile.position.z = y*TerrainTile.TILE_HEIGHT*TerrainTile.V_PPM
			tile.tile_x = x
			tile.tile_y = y
			tile.reset()
			tile.thingy()
			print(x," ",y)
