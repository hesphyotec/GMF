function scrDrawArc(_x,_y ,value, _max, colour, radius, transparency, squash, tilt, thickness){
	if (value <= 0) { // no point even running if there is nothing to display (also stops /0
		return;	
	}
	var i, len, tx, ty, val;
    
	var numberofsections = 120 // there is no draw_get_circle_precision() else I would use that here
	var sizeofsection = 360/numberofsections
    
	val = (value/_max) * numberofsections
    
	if (val > 1) { // HTML5 version doesnt like triangle with only 2 sides
    
	    draw_set_colour(colour);
	    draw_set_alpha(transparency);
        
	    //draw_vertex(_x, _y);
		if (thickness == 1){
			draw_primitive_begin(pr_linestrip);
		    for(i=0; i<=val; i++) {
		        len = (i*sizeofsection)+90 + tilt; // the 90 here is the starting angle
		        tx = lengthdir_x(radius, len);
		        ty = lengthdir_y(radius, len) * squash;
		        draw_vertex(_x+tx, _y+ty);
		    }
		} else if (thickness > 1){
			draw_primitive_begin(pr_trianglestrip);
			for(i=0; i<=val; i++) {
		        len = (i*sizeofsection)+90 + tilt; // the 90 here is the starting angle
		        tx = lengthdir_x(radius, len);
		        ty = lengthdir_y(radius, len) * squash;
		        draw_vertex(_x+tx, _y+ty);
					
				tx = lengthdir_x(radius+thickness, len);
		        ty = lengthdir_y(radius+thickness, len) * squash;
		        draw_vertex(_x+tx, _y+ty);
		    }
		}
	    draw_primitive_end();
        
	}
	draw_set_color(c_white);
	draw_set_alpha(1);
}
