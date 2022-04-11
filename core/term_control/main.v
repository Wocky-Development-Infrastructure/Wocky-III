module term_control

import net

import core

pub fn change_size(r string, c string, mut socket net.TcpConn) {
	socket.write_string("\033[8;${r};${c}t") or { 0 }
}