module wocky

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
	size		string // Expecting a X & Y position
	title		string // [REQUIRED]
	pub mut:
		// Terminal Customization
		current_output			string // Current TUI

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