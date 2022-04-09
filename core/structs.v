module core

import os
import net

pub struct Clients {
	pub mut:
		count		int
		u_names		[]string
		u_sockets	[]net.TcpConn
		u_ips		[]string
		u_ports		[]string
}

pub struct Buffer {
	pub mut:
		full_cmd	string
		cmd			string
		cmd_args	[]string
}

pub struct Terminal {
	pub mut:
		size		string // Expecting a X & Y position
		title		string // [REQUIRED]
		// Hostname Output Customization
		hostname				string // [REQUIRED] [Wocky@Net]~ #
		hostname_position		string // [REQUIRED] Expecting a X & Y position
		cli_cursor				string // [REQUIRED] Expecting a X & Y position

		// CNC Output Customization
		cnc_output_position		string // [REQUIRED] Expecting a X & Y position
		max_output_rows			int // [REQUIRED]
		max_output_width		int // [REQUIRED]
		last_cmd_output			string // Expecting a X & Y position
		cmd_response_output		string // Expecting a X & Y position

		// Online User List
		output_toggle			bool
		output_position 		string
}

/*
	Functions for Buffer Struct
*/
pub fn (mut b Buffer) parse(input string) {
	b.full_cmd = input
	if input.contains(" ") {
		b.cmd_args = input.split(" ")
		b.cmd = b.cmd_args[0]
	} else {
		b.cmd = input
		b.cmd_args << input
	}
}

/*
	Function for Clients Struct
*/

pub fn (mut c Clients) add_session(username string, mut socket net.TcpConn, ip string, port string) {
	c.count++
	c.u_names << username
	c.u_sockets << (mut socket)
	c.u_ips << ip
	c.u_ports << port

}

pub fn (mut c Clients) get_session_info(mut s net.TcpConn) (string, string, string) {
	for i, socket in c.u_sockets {
		if socket == s {
			return c.u_names[i], c.u_ips[i], c.u_ports[i]
		}
	}
	return "", "", ""
}

pub fn (mut c Clients) remove_session(mut s net.TcpConn) {
	for i, socket in c.u_sockets {
		if socket == s {
			c.u_sockets.delete(i)
			c.u_names.delete(i)
			c.u_ips.delete(i)
			c.u_ports.delete(i)
		}
	}
	c.count-=1
}