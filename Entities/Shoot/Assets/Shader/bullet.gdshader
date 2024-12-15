shader_type canvas_item;

// Glow und Standard-Shader-Einstellungen
render_mode blend_add, unshaded;

// Uniform für die Farbe des Glow-Effekts
uniform vec4 glow_color : source_color = vec4(1.0, 1.0, 0.0, 1.0); // Gelb
// Uniform für die Stärke des Glows
uniform float glow_intensity = 1.0;

// Optionale Textur für den Glow
uniform sampler2D glow_texture : source_color;

void fragment() {
    // Berechnung der Texturfarbe basierend auf den UV-Koordinaten
    vec4 tex_color = texture(glow_texture, UV);

    // Kombiniere die Texturfarbe mit der Glow-Farbe und -Intensität
    vec4 combined_color = tex_color * glow_color * glow_intensity;

    // Setze die kombinierte Farbe als Ausgabe
    COLOR = combined_color;
}