shader_type canvas_item;

uniform float tile_factor = 1.0;
uniform float aspect_ratio = 1;

uniform vec2 time_factor = vec2(2.0, 3.0);
uniform vec2 offset_factor = vec2(5.0, 2.0);
uniform vec2 amplitude = vec2(0.05, 0.05);

varying vec2 pos;

void fragment() {
	vec2 tiled_uvs = UV + vec2(50,50);
	tiled_uvs.y *= aspect_ratio;
	
	vec2 wave_uv_offset;
	//(tiled_uvs.x + tiled_uvs.y) 
	wave_uv_offset.x += sin(.57 * TIME * time_factor.x + (tiled_uvs.x + tiled_uvs.y)  * offset_factor.x);
	wave_uv_offset.y += cos(.57 * TIME * time_factor.y + (tiled_uvs.x + tiled_uvs.y)  * offset_factor.y);
	

	COLOR = texture(TEXTURE, tiled_uvs + wave_uv_offset * amplitude);

}

void vertex() {
	//VERTEX += vec2(10,10);
}