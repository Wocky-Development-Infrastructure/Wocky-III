import os

pub const (
	local_fn_file 	= os.getwd() + "/core/wockyfx/wfx_fns.v"
	socket_fn_file	= os.getwd() + "/core/wockyfx/wfx_socket_fns.v"
)

fn main() {
	
}

pub fn get_local_fn_info() {
	mut fn_info := map[string][]string{}
	file_lines := os.read_lines(local_fn_file) or { [''] }
	for i, lines in file_lines {
		if line.contains("(mut wxu WFX_Utils)") {

		}
	}
}