switch(state){
	case TESTOPS.START:
		draw_text(0, 0, "Welcome");
		for(var i = array_length(options) - 1; i >= 0; --i){
			if (i == selected){
				draw_set_color(c_yellow);	
			}
			draw_text(0, 16 + 16*i, getOpText(options[i]));
			draw_set_color(c_white);	
		}
		break;
	case TESTOPS.BUILDTEAM:
		draw_text(0, 0, "Select 3 team members.");
		for(var i = array_length(options) - 1; i >= 0; --i){
			if (i == selected){
				draw_set_color(c_yellow);	
			}
			draw_text(0, 16 + 16*i, getClass(options[i]));
			draw_set_color(c_white);	
		}
		break;
	case TESTOPS.CHOOSEFIGHT:
		draw_text(0, 0, "Ready?");
		break;
}