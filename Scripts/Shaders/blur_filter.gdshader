shader_type canvas_item;

// I'm still not very good at shaders, so it'd probably be better to do your own research, this may very well be wrong and not the best way to do things.

uniform sampler2D screen_texture: hint_screen_texture, filter_linear_mipmap; //The current screen
uniform float blur_amount: hint_range(0.0, 10.0) = 0.0;
uniform float mix_amount: hint_range(0.0, 1.0) = 0.5;

varying vec4 vertex_color; 

void vertex() { // I had to add back the vertex() so that the shader would accept its parent's modulation (for transparency stuffs)
	vertex_color = COLOR;
}

void fragment() {
	vec4 screen_blurred = textureLod(screen_texture, SCREEN_UV, blur_amount); // Blurs by taking the current screen, and giving it an LOD using godot's system I believe.
	vec4 final_color = mix(screen_blurred, COLOR, mix_amount); // Mixes the blurry screen with the initial color of the parent.
	
	COLOR = final_color * vertex_color.a; // Applies the new pixel color.
}