#@tool
class_name TerrainTile
extends Node3D

@export var tile_x: int = 0
@export var tile_y: int = 0
const TILE_WIDTH: int = 256
const TILE_HEIGHT: int = TILE_WIDTH
const H_PPM: float = 0.4965
const V_PPM: float = 0.5000

#@export_tool_button("reset") var _gup2 = reset
#@export_tool_button("hi") var _gup = thingy

func reset():
	$CollisionShape3D.shape = HeightMapShape3D.new()
	$MeshInstance3D.mesh = Mesh.new()

func thingy():
	var start = Time.get_ticks_usec()
	var file_name = "res://terrain/exr_tiles/%02d_%02d.bin" % [tile_x, tile_y]
	print(file_name)
	var f = FileAccess.open(file_name,FileAccess.READ)
	var size = FileAccess.get_size(file_name)
	var width = TILE_WIDTH
	var height = int(size/4/width)
	
	print(width," ",height)
	
	var shape = HeightMapShape3D.new()
	
	shape.map_width = width
	shape.map_depth = height
	
	var data := PackedFloat32Array()
	data.resize(width*height)

	#var minv = 10000
	#var maxv = 0
	
	var idx := 0
	for y in height:
		for x in width:
			var val = f.get_float()-264.443603515625
			#print(val)
			data[idx] = val
			idx += 1
			#minv=min(minv,val)
			#maxv=max(maxv,val)
	
	f.close()
	
	#print(minv," ",maxv)
	
	shape.map_data = data
	$CollisionShape3D.shape = shape
	$CollisionShape3D.scale.x = 1.0/float(width)
	$CollisionShape3D.scale.z = 1.0/float(height)
	$CollisionShape3D.scale.y = 1
	$CollisionShape3D.position = (Vector3(0.5,0,0.5))
	
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for y in height-1:
		for x in width-1:
			var points = []
			for off in [[0,0],[1,0],[0,1],[1,1]]:
				var val = data[x+off[0] + (y+off[1])*width]
				points.append(Vector3(
					(x+off[0])/float(width),
					val,
					(y+off[1])/float(height),
				))
			st.add_vertex(points[0])
			st.add_vertex(points[1])
			st.add_vertex(points[2])
			
			st.add_vertex(points[2])
			st.add_vertex(points[1])
			st.add_vertex(points[3])
	
	st.index()
	st.generate_normals()
	$MeshInstance3D.mesh = st.commit()
	
	
	$CollisionShape3D.scale.x *= float(TILE_WIDTH) * H_PPM
	$MeshInstance3D.scale.x   *= float(TILE_WIDTH) * H_PPM
	
	$CollisionShape3D.scale.z *= float(TILE_HEIGHT) * V_PPM
	$MeshInstance3D.scale.z   *= float(TILE_HEIGHT) * V_PPM
	
	var end = Time.get_ticks_usec()
	print("it took %f ms" % ((end-start)/1000.0))
