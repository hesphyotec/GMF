scrGetInput();
if (active){
	writeDiag();
	if (array_length(choices) > 0){
		if (upPress) {
			selection = ((selection - 1) + array_length(choices)) mod array_length(choices);
		}
		if (downPress) {
			selection = ((selection + 1) + array_length(choices)) mod array_length(choices);
		}
	}
}
