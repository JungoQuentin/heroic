shader_type spatial;
render_mode world_vertex_coords;

uniform sampler2D albedo_tex : source_color, filter_linear_mipmap_anisotropic;

uniform float world_scale = 1.0;
uniform float rotation_deg : hint_range(0.0, 360.0) = 0.0;

// 0 = XY, 1 = XZ, 2 = YZ
uniform int projection_plane : hint_enum("XY","XZ","YZ") = 1;

// pivot dans l’espace UV (après world_scale)
uniform vec2 rotation_pivot = vec2(0.0, 0.0);

varying vec3 world_pos;

vec2 rotate_uv(vec2 uv, float angle_rad, vec2 pivot) {
    uv -= pivot;
    float c = cos(angle_rad);
    float s = sin(angle_rad);
    mat2 rot = mat2(vec2(c, s), vec2(-s, c));
    uv = rot * uv;
    return uv + pivot;
}

vec2 project_uv(vec3 wp) {
    if (projection_plane == 0) { // XY
        return wp.xy * world_scale;
    } else if (projection_plane == 2) { // YZ
        return wp.yz * world_scale;
    }
    // XZ (par défaut)
    return wp.xz * world_scale;
}

void vertex() {
    world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
    vec2 uvs = project_uv(world_pos);
    uvs = rotate_uv(uvs, radians(rotation_deg), rotation_pivot);

    vec3 col = texture(albedo_tex, uvs).rgb;
    ALBEDO = col;
}
