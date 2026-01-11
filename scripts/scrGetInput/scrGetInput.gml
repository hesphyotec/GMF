function scrGetInput(){
	if (!variable_instance_exists(id, "left")){
		left = false;
		right = false;
		down = false;
		up = false;
		sprint = false;
		interact = false;
		lClick = false;
	}
	var prevLeft = left;
	var prevRight = right;
	var prevUp = up;
	var prevDown = down;
	var prevSprint = sprint;
	var prevInteract = interact;
	var prevLClick = lClick;
	
	left = keyboard_check(vk_left) || keyboard_check(ord("A"));
	up = keyboard_check(vk_up) || keyboard_check(ord("W"));
	right = keyboard_check(vk_right) || keyboard_check(ord("D"));
	down = keyboard_check(vk_down) || keyboard_check(ord("S"));
	debug = keyboard_check(vk_f1);
	sprint = keyboard_check(vk_shift) || keyboard_check(ord("X"));
	interact = keyboard_check(vk_enter) || keyboard_check(ord("Z"));
	lClick = mouse_check_button(mb_left);
	//rClick = mouse_check_button(mb_right);
	
	leftPress		= (left && !prevLeft);
	rightPress		= (right && !prevRight);
	downPress		= (down && !prevDown);
	upPress			= (up && !prevUp);
	sprintPress		= (sprint && !prevSprint);
	interactPress	= (interact && !prevInteract);
	lClickPress		= (lClick && !prevLClick);

	
	leftRelease			= (!left && prevLeft);
	rightRelease		= (!right && prevRight);
	downRelease			= (!down && prevDown);
	upRelease			= (!up && prevUp);
	sprintRelease		= (!sprint && prevSprint);
	interactRelease		= (!interact && prevInteract);
	lClickRelease		= (!lClick && prevLClick);
}