shader_type canvas_item;

// "blend_add" für additiven (Neon-)Effekt, "unshaded" ignoriert Lichtberechnungen
render_mode blend_add, unshaded;

// Einfärbung des Lasers
uniform vec4 laser_color : source_color = vec4(0.5, 0.8, 1.0, 1.0);

// Das hier war "laser_width" – wird aber in 'Line2D.width' im GDScript gesteuert.
// Wenn du es nur im Shader nutzen möchtest, kannst du es z.B. UV-skalieren lassen.
uniform float laser_width = 0.5;

// PNG-Textur für den Laser
uniform sampler2D laser_texture : hint_albedo;

// Skalierung für das UV-Mapping der Textur
uniform float uv_scale = 1.0;


void fragment() {
    // Textur holen (per default: UV in [0,1], aber bei Line2D kommt's auf den "texture_mode" an)
    vec4 tex_color = texture(laser_texture, UV * uv_scale);

    // Multiplikation mit laser_color für Einfärbung / Modulation
    vec4 final_color = tex_color * laser_color;

    COLOR = final_color;
}
