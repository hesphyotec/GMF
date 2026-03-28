function createOWScreenFadeOut(X, Y, fadeAMT, col, sprite = sprEmpty){
	var eff = instance_create_layer(X, Y, "Backend", objOWEffect);
	eff.isSprite = false;
	eff.sprite_index = sprite;
	eff.isScreen = true;
	eff.persist = false;
	eff.fade = true;
	eff.follow = undefined;
	eff.screenInfo.col = col;
	eff.fadeIn = false;
	eff.screenInfo.a = 1;
	eff.screenInfo.fadeAMT = fadeAMT;
	return eff;
}