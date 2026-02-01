@tool
extends MeshInstance3D

@export_node_path("CollisionPolygon2D") var source_collision_poly: NodePath
@export_node_path("Polygon2D") var source_polygon2d: NodePath

@export var pixels_per_unit: float = 100.0:
	set(value):
		pixels_per_unit = max(0.0001, value)
		if Engine.is_editor_hint():
			regenerate()

@export var thickness: float = 0.1:
	set(value):
		thickness = value
		if Engine.is_editor_hint():
			regenerate()

@export var texture_tile_scale: float = 1.0:
	set(value):
		texture_tile_scale = value
		if Engine.is_editor_hint():
			regenerate()

@export var double_sided: bool = true:
	set(value):
		double_sided = value
		if Engine.is_editor_hint():
			regenerate()

@export var center_polygon: bool = true:
	set(value):
		center_polygon = value
		if Engine.is_editor_hint():
			regenerate()

@export var face_material: Material:
	set(value):
		face_material = value
		if Engine.is_editor_hint():
			regenerate()

@export var side_material: Material:
	set(value):
		side_material = value
		if Engine.is_editor_hint():
			regenerate()


func _ready():
	if Engine.is_editor_hint():
		regenerate()


func _get_polygon() -> PackedVector2Array:
	if source_collision_poly != NodePath():
		var n := get_node_or_null(source_collision_poly)
		if n and n is CollisionPolygon2D:
			return (n as CollisionPolygon2D).polygon

	if source_polygon2d != NodePath():
		var n2 := get_node_or_null(source_polygon2d)
		if n2 and n2 is Polygon2D:
			return (n2 as Polygon2D).polygon

	return PackedVector2Array()


func _compute_face_uv(p: Vector2, minv: Vector2, size: Vector2) -> Vector2:
	return Vector2(
		(p.x - minv.x) / size.x,
		1.0 - (p.y - minv.y) / size.y
	)


func _fix_polygon(poly_in: PackedVector2Array) -> PackedVector2Array:
	var poly := poly_in.duplicate()

	if center_polygon:
		var c := Vector2.ZERO
		for p in poly:
			c += p
		c /= float(poly.size())
		for i in poly.size():
			poly[i] -= c

	for i in poly.size():
		poly[i].y = -poly[i].y

	for i in poly.size():
		poly[i] /= pixels_per_unit

	if Geometry2D.is_polygon_clockwise(poly):
		poly.reverse()

	return poly


func regenerate():
	var src_poly := _get_polygon()
	if src_poly.size() < 3:
		return

	var poly := _fix_polygon(src_poly)

	var indices := Geometry2D.triangulate_polygon(poly)
	if indices.is_empty():
		return

	var minv := poly[0]
	var maxv := poly[0]
	for p in poly:
		minv.x = min(minv.x, p.x)
		minv.y = min(minv.y, p.y)
		maxv.x = max(maxv.x, p.x)
		maxv.y = max(maxv.y, p.y)

	var size := maxv - minv
	if abs(size.x) < 0.00001:
		size.x = 1.0
	if abs(size.y) < 0.00001:
		size.y = 1.0

	var zf := thickness * 0.5
	var zb := -thickness * 0.5

	var mesh_out := ArrayMesh.new()

	var st_face := SurfaceTool.new()
	st_face.begin(Mesh.PRIMITIVE_TRIANGLES)

	for i in range(0, indices.size(), 3):
		var a2 := poly[indices[i]]
		var b2 := poly[indices[i + 1]]
		var c2 := poly[indices[i + 2]]

		var a3 := Vector3(a2.x, a2.y, zf)
		var b3 := Vector3(b2.x, b2.y, zf)
		var c3 := Vector3(c2.x, c2.y, zf)

		var uva := _compute_face_uv(a2, minv, size)
		var uvb := _compute_face_uv(b2, minv, size)
		var uvc := _compute_face_uv(c2, minv, size)

		_add_tri(st_face, a3, b3, c3, uva, uvb, uvc, Vector3(0, 0, 1))

	if double_sided:
		for i in range(0, indices.size(), 3):
			var a2 := poly[indices[i]]
			var b2 := poly[indices[i + 1]]
			var c2 := poly[indices[i + 2]]

			var a3 := Vector3(a2.x, a2.y, zb)
			var b3 := Vector3(b2.x, b2.y, zb)
			var c3 := Vector3(c2.x, c2.y, zb)

			var uva := _compute_face_uv(a2, minv, size)
			var uvb := _compute_face_uv(b2, minv, size)
			var uvc := _compute_face_uv(c2, minv, size)

			_add_tri(st_face, c3, b3, a3, uvc, uvb, uva, Vector3(0, 0, -1))

	st_face.generate_normals()
	st_face.commit(mesh_out)
	mesh_out.surface_set_material(0, face_material)

	var st_side := SurfaceTool.new()
	st_side.begin(Mesh.PRIMITIVE_TRIANGLES)

	var perim := 0.0
	for i in poly.size():
		perim += poly[i].distance_to(poly[(i + 1) % poly.size()])
	if perim < 0.00001:
		perim = 1.0

	var acc := 0.0
	for i in poly.size():
		var p0 := poly[i]
		var p1 := poly[(i + 1) % poly.size()]
		var edge_len := p0.distance_to(p1)

		var u0 := (acc / perim) * texture_tile_scale
		var u1 := ((acc + edge_len) / perim) * texture_tile_scale
		acc += edge_len

		var a0 := Vector3(p0.x, p0.y, zf)
		var a1 := Vector3(p1.x, p1.y, zf)
		var b1 := Vector3(p1.x, p1.y, zb)
		var b0 := Vector3(p0.x, p0.y, zb)

		var e := (p1 - p0).normalized()
		var n2 := Vector2(-e.y, e.x)
		var n := Vector3(n2.x, n2.y, 0).normalized()

		_add_tri(st_side, a0, a1, b1, Vector2(u0, 0), Vector2(u1, 0), Vector2(u1, 1), n)
		_add_tri(st_side, a0, b1, b0, Vector2(u0, 0), Vector2(u1, 1), Vector2(u0, 1), n)

	st_side.generate_normals()
	st_side.commit(mesh_out)
	mesh_out.surface_set_material(1, side_material)

	mesh = mesh_out


func _add_tri(
	st: SurfaceTool,
	v0: Vector3, v1: Vector3, v2: Vector3,
	uv0: Vector2, uv1: Vector2, uv2: Vector2,
	n: Vector3
) -> void:
	st.set_normal(n)
	st.set_uv(uv0)
	st.add_vertex(v0)

	st.set_normal(n)
	st.set_uv(uv1)
	st.add_vertex(v1)

	st.set_normal(n)
	st.set_uv(uv2)
	st.add_vertex(v2)
