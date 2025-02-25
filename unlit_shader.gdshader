shader_type spatial;
render_mode unshaded;

uniform sampler2D texture_map : filter_nearest;
uniform sampler2D light_map : filter_nearest;

void fragment() {
    vec4 tex_color = texture(texture_map, UV);
    float light_intensity = texture(light_map, UV).r;
    vec3 light_color;
    if (light_intensity > 0.833) {
        light_color = vec3(1.0, 1.0, 1.0);
    } else if (light_intensity > 0.666) {
        light_color = vec3(1.0, 0.80, 0.60);
    } else if (light_intensity > 0.5) {
        light_color = vec3(0.78, 0.54, 0.37);
    } else if (light_intensity > 0.333) {
        light_color = vec3(0.48, 0.35, 0.24);
    } else if (light_intensity > 0.166) {
        light_color = vec3(0.29, 0.24, 0.16);
    } else {
        light_color = vec3(0.18, 0.18, 0.18);
    }
    ALBEDO = tex_color.rgb * light_color;
    ALPHA = tex_color.a;
}