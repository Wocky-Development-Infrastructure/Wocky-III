module wockyfx

import os
import net
import config
import utilities

pub struct WockyFX {
	pub mut:
		file			string
		file_data		[]string

		current_output	string
		perm			int

		variables 		map[string]string

		socket_toggle	bool
		socket			net.TcpConn

		fcmd			string
		cmd 			string
		cmd_args		[]string

		online_users	string
}

pub const (
	wfx_perm 		= ['free', 'reseller', 'admin', 'owner']
						// Colors
	wfx_variables 	= ['Default', 'Black', 'Red', 'Green', 'Yellow', 'Blue', 'Purple', 'Cyan',
						'Light_Grey', 'Dark_Grey', 'Light_Red', 'Light_Green', 'Light_Yellow',
						'Light_Blue', 'Light_Purple', 'Light_Cyan', 'White',
						// Background Colors
						'Default_BG', 'Black_BG', 'Red_BG', 'Green_BG', 'Yellow_BG', 'Blue_BG', 'Purple_BG',
						'Cyan_BG', 'Light_Gray_BG', 'Dark_Gray_BG', 'Light_Red_BG', 'Light_Green_BG', 'Light_Yellow_BG',
						'Light_Blue_BG', 'Light_Purple_BG', 'Light_Cyan_BG', 'White_BG']
	wfx_fns 		= ['sleep', //0
			   			'clear', // 1
			   			'get_args', //2
						'output_wrfx' //3
						'print_text', //4
						'place_text', //5
						'list_text',  //6
						'hide_cursor', //7
						'show_cursor', // 8
						'slow_place_text', // 9
						'set_term_size', // 10
						'change_term_title', // 11
						'move_cursor', // 12
						'send_attack', // 13
						'include_wfx', // 14
						'geo_ip', // 15
						'set_max_arg', // 16
						'set_arg_err_msg' // 17
						]
	wfx_loops		= ['for']
)

pub fn (mut wx WockyFX) set_file(file string) {
	if wockyfx.check_for_wfx_file(file) {
		wx.file_data = os.read_lines(os.getwd() + "/assets/wockyfx/${file}.wfx") or { [''] }
	} else if wockyfx.check_for_wfx_cmd(file) {
		wx.file_data = os.read_lines(os.getwd() + "/assets/wockyfx/${file}_cmd.wfx") or { [''] }
	}
}

pub fn (mut wx WockyFX) add_variable(var_name string, var_value string) {
	wx.variables[var_name] = var_value
}

pub fn (mut wx WockyFX) change_var_value(var_name string, var_value string) {
	wx.variables[var_name] = var_value
}

pub fn (mut wx WockyFX) append_var_value(var_name string, var_value string) {
	wx.variables[var_name] += var_value
}

pub fn (mut wx WockyFX) add_buffer_info(fc string, c string, arg []string) {
	wx.fcmd = fc
	wx.cmd = c 
	wx.cmd_args = arg
}

pub fn (mut wx WockyFX) enable_socket_mode(mut s net.TcpConn) {
	wx.socket_toggle = true
	wx.socket = s
}

pub fn (mut wx WockyFX) disable_socket_mode() {
	wx.socket_toggle = false
}

pub fn wfx_parse_callback(mut wx WockyFX, file string, function string) {

	exit_code, new_code := wockyfx.get_callback_code(file, function)
	mut new_filecode := ""
	for i, line_code in new_code {
		new_filecode += "${line_code}\n"
	}

	new_filename := utilities.create_random_str(10)
	
	filepath := os.getwd() + "/assets/wockyfx/${new_filename}.wfx"
	os.write_file(filepath, new_filecode) or { panic("Failed") }

	wockyfx(mut wx, new_filename)
	os.execute("sudo rm -rf ${filepath}").output
}

pub fn wockyfx(mut wx WockyFX, file string) {
	mut ui := []string
	if wockyfx.check_for_wfx_file(file) {
		ui = os.read_lines(os.getwd() + "/assets/wockyfx/${file}.wfx") or { [''] }
	} else if wockyfx.check_for_wfx_cmd(file) {
		ui = os.read_lines(os.getwd() + "/assets/wockyfx/${file}_cmd.wfx") or { [''] }
	}
	wx.file = file
	wx.file_data = ui
	// Validating perm key in free line

	mut file_perm := 0

	if ui.len > 1 {
		if ui[0].starts_with("perm") {
			file_perm = wockyfx.parse_perm(ui[0])
			if file_perm > wx.perm {
				println("[x] Error, This command is for a high rank....!")
				return
			}
		} else {
			// err and exit
			println("[x] Error, No perms found for this command")
			return
		}
	}

	
	mut max, err := wockyfx.check_for_max_arg(mut wx)
	
	/*
		Variable are replaced so function names and for key is what we need to parse here
	*/
	mut fn_found := false
	for i, linee in wx.file_data {
		mut line := linee
		if line != "" { 
			if line.starts_with("perm") { continue }
			if line.contains("//") {
				line = line.split("//")[0]
			}

			if line.starts_with(wfx_loops[0]) {
				// parse for loop (later)
			} else if line.starts_with("var") {
				// parse variable
			} else {
				for d, fn_n in wfx_fns {
					if line.starts_with(fn_n) {
						wockyfx.parse_fns(line, file, i, wx.socket_toggle, mut wx.socket, mut wx)
						fn_found = true
					}
				}

				if fn_found == false {
					// output text (no functions or for loop)
					mut fix := wockyfx.replace_code(line)
					if wx.socket_toggle == true {
						wx.socket.write_string(fix) or { 0 }
					} else {
						// print(fix)
					}
				}
			}
		}
	}
}