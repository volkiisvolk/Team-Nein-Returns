shader_type canvas_item;

uniform vec4 laser_color : source_color = vec4(0.1, 0.9, 1.0, 1.0); // Standard Neon-Hellblau
uniform float laser_width = 0.5; // Standardbreite des Lasers

void fragment() {
    // Setze die Farbe des Pixels auf laser_color
    COLOR = laser_color;
}
