function createOWEffect(X, Y, lay, sprite, follow = undefined, persist = false, fade = false, fadeIn = false, fadeAMT = 0, col = c_white, a = 1){
	var eff = instance_create_layer(X, Y, lay, objOWEffect);
	eff.isSprite = true;
	eff.sprite_index = sprite;
	eff.isScreen = false;
	eff.persist = persist;
	eff.fade = fade;
	eff.fadeIn = fadeIn;
	eff.follow = follow;
	eff.screenInfo.col = col;
	eff.screenInfo.a = a;
	eff.screenInfo.fadeAMT = fadeAMT;
	return eff;
}