module term_control

pub fn gradiant(startrgb int, endrgb int, text string) {
	changer = endrgb[0] - startrgb[0] / text.len
	changeg = endrgb[1] - startrgb[1] / text.len
	changeb = endrgb[2] - startrgb[2] / text.len
	
	r = startrgb[0]
	g = startrgb[1]
	b = startrgb[2]
	
	for letter in text {
		println("\x1b[38;2;${r};${g};${b}m${letter}")
	}

	r += changer
	g += changeg
	b += changeb
}
