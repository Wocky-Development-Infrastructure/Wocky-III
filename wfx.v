/*
	WockyFX Module

	This is an example on how to use the WockyFX Module.

	Certain Functions are commented out like the socket functions
	due to the reason of creating this app only to debug the module
	and use as an example
*/
import os

import core.config
import core.wockyfx

fn main() {
	if cmd_args.len < 2 {
		println("[x] Error, Invalid argument\r\nUsage: ${cmd_args[0]} <wfx_filepath>")
		exit(0)
	}

	// Parsing Command
	cmd_args := os.args.clone()
	full_cmd := ""
	cmd := cmd_args[0]
	for i, arg in cmd_args { if i == cmd_args.len { full_cmd += "${arg}" } else { full_cmd += "${arg} " } }

	// Start WFX Session (Returns WFX Struct)
	mut wfx := wockyfx.start_session()

	// Enable Socket Mode ( THIS FUNCTION IS FOR SOCKET APPS )
	// wfx.enable_socket_mode(mut socket)

	wfx.set_buffer(full_cmd, cmd, cmd_args)

	// Set User Information ( MUST BE A MAP )
	mut user_acc := map[string]string
	user_acc['username'] = "Test"
	wfx.set_info(user_acc)

	wfx.add_variable("{USERNAME}", user_acc['username'], "str")

	// Set WFX File Path AND Type
	wfx.set_file(config.wfx_path + cmd_args[1], wockyfx.FileTypes.wfx) // set file to parse
	// Start Parsing and Executing Code
	wfx.parse_wfx() // parse it

	// Disable Socket Mode
	wfx.disable_socket_mode()
}