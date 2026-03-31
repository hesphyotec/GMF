varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float amount;

void main()
{
	vec4 baseTex = texture2D( gm_BaseTexture, v_vTexcoord );
	vec4 colorMask = vec4(1., 1., 1., baseTex.a) * v_vColour;
	vec4 newTex = mix(baseTex, colorMask, clamp(amount, 0.0, 1.0));
	
    gl_FragColor = newTex;
}
