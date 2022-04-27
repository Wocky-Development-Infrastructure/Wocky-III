module wockyfx

import os
import net
import time
import wockyfx

pub fn (mut wxu WFX_Utils) wfx_clear_socket(mut socket net.TcpConn) {
	socket.write_string("\033[2J\033[1;1H") or { 0 }
}

pub fn (mut wxu WFX_Utils) wfx_hide_cursor_socket(mut socket net.TcpConn) {
	socket.write_string("\033[?25l") or { 0 }
}

pub fn (mut wxu WFX_Utils) wfx_show_cursor_socket(mut socket net.TcpConn) {
	socket.write_string("\033[?25h\033[?0c") or { 0 }
}

pub fn (mut wxu WFX_Utils) wfx_set_term_size_socket(r string, c string, mut socket net.TcpConn) {
	socket.write_string("\033[8;${r};${c}t") or { }
}

pub fn (mut wxu WFX_Utils) wfx_change_term_title_socket(t string, mut socket net.TcpConn) {
	socket.write_string("\033]0;${t}\007") or { 0 }
}

pub fn (mut wxu WFX_Utils) wfx_move_cursor_socket(r string, c string, mut socket net.TcpConn) {
	socket.write_string("\033[${r};${c}f") or { 0 }
}

pub fn (mut wxu WFX_Utils) wfx_place_text_socket(r string, c string, t string, mut socket net.TcpConn) {
	socket.write_string("\033[${r};${c}f${t}") or { 0 }
}

pub fn (mut wxu WFX_Utils) wfx_slow_place_text_socket(r string, c string, tme string, milli_or_seconds string, gg string, mut socket net.TcpConn) {
	mut start_c := c.int()
	for i, letter in gg {
		current_c := letter.ascii_str()
		socket.write_string("\033[${r};${start_c}f${current_c}") or { 0 }
		if milli_or_seconds == "millisecond" {
			time.sleep(tme.int()*time.millisecond)
		} else {
			time.sleep(tme.int()*time.second)
		}
		start_c++
	}
}

pub fn (mut wxu WFX_Utils) wfx_list_text_socket(r string, c string, gg string, mut sock net.TcpConn) {
	mut socket := sock
	mut start_c := r.int()
	for i, letter in gg.split("\n") {
		socket.write_string("\033[${start_c};${c}f${letter}") or { 0 }
		start_c++
	}
}

pub fn (mut wxu WFX_Utils) wfx_slow_list_text_socket(r string, c string, tme string, milli_or_seconds string, gg string, mut sock net.TcpConn) {
	mut socket := sock
	mut start_c := r.int()
	mut t := wockyfx.replace_code(gg)
	for i, letter in t.split("\n") {
		socket.write_string("\033[${start_c};${c}f${letter}") or { 0 }
		if milli_or_seconds == "millisecond" {
			time.sleep(tme.int()*time.millisecond)
		} else {
			time.sleep(tme.int()*time.second)
		}
		start_c++
	}
}

pub fn (mut wxu WFX_Utils) wfx_output_wrfx_socket(file string, mut sock net.TcpConn) {
	mut socket := sock
	mut file_data := os.read_lines(file) or { 
		println("error reading file") 
		return
	}

	for i, line in file_data {
		mut fix := wockyfx.replace_code(line) // replacing_veriables
		if i == file_data.len-1 {
			socket.write_string(fix.trim_space()) or { 0 }
		} else {
			fix += "\r\n"
			socket.write_string(fix) or { 0 }
		}
	}
}