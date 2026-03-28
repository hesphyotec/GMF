scrGetInput();
if (active){
	writeDiag();
	if (array_length(choices) > 0){
		if (leftPress) {
			selection = ((selection - 1) + array_length(choices)) mod array_length(choices);
		}
		if (rightPress) {
			selection = ((selection + 1) + array_length(choices)) mod array_length(choices);
		}
	}
}
