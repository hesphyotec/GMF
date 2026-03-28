varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform sampler2D sprite2;
uniform float ratio;

void main(){
	vec4 baseTexColor = texture2D( gm_BaseTexture, v_vTexcoord );
	vec4 newTexColor = texture2D( sprite2, v_vTexcoord );
	
	vec4 finalTexColor = mix(baseTexColor, newTexColor, ratio);
	
    gl_FragColor = v_vColour * finalTexColor;
}
