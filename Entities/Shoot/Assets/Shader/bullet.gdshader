	shader_type canvas_item;
		// Additive Mischung für Neon-Effekt, unshaded ignoriert Lichter
		render_mode blend_add, unshaded;

		uniform vec4 laser_color : source_color = vec4(0.5, 0.8, 1.0, 1.0);
		uniform float laser_width = 0.5;

		// PNG-Textur (Laser-Look)
		uniform sampler2D laser_texture : source_color;
		// Steuert das UV-Mapping (Kachelung)
		uniform float uv_scale = 1.0;

		void fragment() {
			vec4 tex_color = texture(laser_texture, UV * uv_scale);
			// Laserfarbe und Textur kombinieren
			COLOR = tex_color * laser_color;
		}