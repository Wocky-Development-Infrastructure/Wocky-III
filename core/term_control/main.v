module term_control

import net

import core

pub fn change_size(r string, c string, mut socket net.TcpConn) {
	socket.write_string("\033[8;${r};${c}t") or { 0 }
}

pub fn change_title(t string, mut socket net.TcpConn) {
	socket.write_string("\033]0;${t}\007") or { 0 }
}


pub fn place_text_sock(r string, c string, t string, mut s net.TcpConn) {
	s.write_string("\033[${r};${c}f${t}") or { 0 }
}