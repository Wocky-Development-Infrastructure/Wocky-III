module wockyfx

import os
import net
import time
import wockyfx

pub fn wfx_sleep(c int) {
	time.sleep(c*time.second)
}

pub fn wfx_clear() {
	print("\033[2J\033[1;1H")
}

pub fn wfx_clear_sock(mut s net.TcpConn) {
	s.write_string("\033[2J\033[1;1H") or { 0 }
}

pub fn wfx_output_wrfx(file string) {
	mut file_data := os.read_lines(os.getwd() + "/assets/wockyfx/wrfx/${file}.wrfx") or { [''] }

	for i, line in file_data {
		mut fix := wockyfx.replace_code(line) // replacing_veriables
		if i == file_data.len-1 {
			print(fix.trim_space())
		} else {
			fix += "\r\n"
			print(fix)
		}
	}
}

pub fn wfx_output_wrfx_sock(file string, mut s net.TcpConn) {
	mut file_data := os.read_lines(os.getwd() + "/assets/wockyfx/wrfx/${file}.wrfx") or { [''] }

	for i, line in file_data {
		mut fix := wockyfx.replace_code(line) // replacing_veriables
		if i == file_data.len-1 {
			s.write_string(fix.trim_space()) or { 0 }
		} else {
			fix += "\r\n"
			s.write_string(fix) or { 0 }
		}
	}
}

pub fn wfx_place_text(r string, c string, t string) {
	print("\033[${r};${c}f${t}")
}

pub fn wfx_place_text_sock(r string, c string, t string, mut s net.TcpConn) {
	s.write_string("\033[${r};${c}f${t}") or { 0 }
}

pub fn wfx_hide_cursor() {
	print("\x1b[?251")
}

pub fn wfx_hide_cursor_sock(mut s net.TcpConn) {
	s.write_string("\033[?251") or { 0 }
}

pub fn wfx_show_cursor() {
	print("\033[?25h\033[?0c")
}

pub fn wfx_show_cursor_sock(mut s net.TcpConn) {
	s.write_string("\033[?25h\033[?0c") or { 0 }
}