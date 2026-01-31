shader_type spatial;
render_mode world_vertex_coords;

uniform sampler2D albedo_tex : source_color, filter_linear_mipmap_anisotropic;
uniform float world_scale = 1.0;          // tiling
uniform float rotation_deg = 0.0;         // rotation en degrés
uniform vec2 rotation_pivot = vec2(0.0);  // pivot en "world UV space" (xz * scale)

varying vec3 world_pos;

vec2 rotate_uv(vec2 uv, float angle_rad, vec2 pivot) {
    uv -= pivot;

    float c = cos(angle_rad);
    float s = sin(angle_rad);

    // Godot: mat2 = mat2(vec2(col0), vec2(col1))
    mat2 rot = mat2(vec2(c, s), vec2(-s, c)); // rotation standard

    uv = rot * uv;
    uv += pivot;
    return uv;
}

void vertex() {
    world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
    vec2 uvs = world_pos.xz * world_scale;

    float ang = radians(rotation_deg);
    uvs = rotate_uv(uvs, ang, rotation_pivot);

    vec3 col = texture(albedo_tex, uvs).rgb;
    ALBEDO = col;
}
