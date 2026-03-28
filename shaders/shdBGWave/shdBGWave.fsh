//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform float time;
void main()
{
	vec4 rcol = vec4(abs(sin(time)), abs(cos(time)), abs(sin(time * 2.)), .5);
	
	float amplitude = .005;     // how far left/right it moves
    float frequency = 10.;    // how tight the waves are
    float speed = 3.0;         // wave movement speed

    float wave = sin(v_vTexcoord.y * frequency + time * speed) * amplitude;
	
	vec2 newTexCoord = vec2(v_vTexcoord.x + wave, v_vTexcoord.y);
    gl_FragColor = rcol * texture2D( gm_BaseTexture, newTexCoord );
}
