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

pub fn wfx_output_wfx(mut wx wockyfx.WockyFX, file string) {
	wockyfx.wockyfx(mut wx, file)
}

pub fn wfx_output_wfx_sock(mut wx wockyfx.WockyFX, file string) {
	wockyfx.wockyfx(mut wx, file)
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

pub fn wfx_list_text(r string, c string, gg string) {
	mut start_c := r.int()
	mut t := wockyfx.replace_code(gg)
	for i, letter in t.split("\n") {
		print("\033[${start_c};${c}f${letter}")
		time.sleep(500*time.millisecond)
		start_c++
	}
}

pub fn wfx_list_text_sock(r string, c string, gg string, mut s net.TcpConn) {
	mut start_c := r.int()
	mut t := wockyfx.replace_code(gg)
	for i, letter in t.split("\n") {
		s.write_string("\033[${start_c};${c}f${letter}") or { 0 }
		time.sleep(500*time.millisecond)
		start_c++
	}
}

pub fn wfx_slow_place_text(r string, c string, gg string) {
	mut start_c := c.int()
	mut t := wockyfx.replace_code(gg)
	for i, letter in t {
		current_c := letter.ascii_str()
		print("\033[${r};${start_c}f${current_c}")
		time.sleep(500*time.millisecond)
		start_c++
	}
}

pub fn wfx_slow_place_text_sock(r string, c string, gg string, mut s net.TcpConn) {
	mut start_c := c.int()
	mut t := wockyfx.replace_code(gg)
	for i, letter in t {
		current_c := letter.ascii_str()
		s.write_string("\033[${r};${start_c}f${current_c}") or { 0 }
		time.sleep(500*time.millisecond)
		start_c++
	}
}

pub fn wfx_hide_cursor() {
	print("\x1b[?25l")
}

pub fn wfx_hide_cursor_sock(mut s net.TcpConn) {
	s.write_string("\033[?25l") or { 0 }
}

pub fn wfx_show_cursor() {
	print("\033[?25h\033[?0c")
}

pub fn wfx_show_cursor_sock(mut s net.TcpConn) {
	s.write_string("\033[?25h\033[?0c") or { 0 }
}

pub fn wfx_set_term_size(r string, c string) {
	print("\033[8;${r};${c}t")
}

pub fn wfx_set_term_size_sock(r string, c string, mut s net.TcpConn) {
	s.write_string("\033[8;${r};${c}t") or { }
}

pub fn wfx_change_term_title(t string) {
	print("\033]0;${t}\007")
}

pub fn wfx_change_term_title_sock(t string, mut s net.TcpConn) {
	s.write_string("\033]0;${t}\007") or { 0 }
}

pub fn wfx_move_cursor(r string, c string) {
	print("\033[${r};${c}f")
}

pub fn wfx_move_cursor_sock(r string, c string, mut s net.TcpConn) {
	s.write_string("\033[${r};${c}f") or { 0 }
}