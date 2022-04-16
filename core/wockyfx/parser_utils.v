module wockyfx

import os
import net
import wockyfx
import config

pub fn check_for_wfx_file(filename string) bool {
	if os.exists(os.getwd() + "/assets/wockyfx/${filename}.wfx") {
		return true
	}
	return false
}

pub fn check_for_wfx_cmd(filename string) bool {
	if os.exists(os.getwd() + "/assets/wockyfx/${filename}_cmd.wfx") {
		return true
	}
	return false
}

pub fn get_all_cmds() []string {
	all_files := os.ls(os.getwd() + "/assets/wockyfx") or { [''] }
	mut all_commands := []string
	for i, file in all_files {
		if file.ends_with("_cmd.wfx") {
			all_commands << file.replace("_cmd.wfx", "")
		}
	}
	return all_commands
}

pub fn check_for_wfx_cmd_data(filename string) bool {
	mut file := os.read_file(os.getwd() + "/assets/wockyfx/${filename}_cmd.wfx") or { "" }
	if file == "" || file.len == 0 {
		return false
	}
	return true
}

pub fn check_for_wfx_data(filename string) bool {
	mut file := os.read_file(os.getwd() + "/assets/wockyfx/${filename}.wfx") or { "" }
	if file == "" || file.len == 0 {
		return false
	}
	return true
}

pub fn parse_perm(line string) int {
	if line.starts_with("perm ") {
		check_for_rank := line.split(" ")
		if check_for_rank[1].int() == 1 {
			return 1
		}
	}
	return 0
}

pub fn validate_perm(file_perm int, user_info map[string]string) {

}

pub fn parse_fns(line string, filename string, line_count int, socket_t bool, mut socket net.TcpConn, mut wx WockyFX) {
	if line == "" { return }
	mut fn_found := false

	mut fn_err := false
	mut fn_err_msg := ""

	mut fn_name := ""
	mut fn_args := []string

	if line.contains("(") {
		if line.ends_with(");") {
			mut check_fn := line.split("(")[0]
			if check_fn in wockyfx.wfx_fns {
				fn_name = check_fn
				fn_args = grab_fn_args(line)
				if fn_err == true && fn_err_msg.split("\n").len > 2 {
					print(fn_err_msg)
					return
				}
				exec_fn(fn_name, fn_args, socket_t, mut socket, mut wx)
				fn_found = true 
			} else {
				// found an unknown function (Invalid syntax)
				fn_err = true
				fn_err_msg = "[x] Error (FILE:${filename}|L#${line_count}), Found an unknown function (Invalid syntax)\r\n"
			}
		} else {
			// Missing ending parathensis or semi-colon
			fn_err = true
			fn_err_msg = "\r\n[x] Error (FILE:${filename}|L#${line_count}), Invalid syntax. Missing closing parathensis ')' or semi-colon ';'\r\n[x] Error Preview, ${line}"
		}
	} else {
		// Missing parathensis 
		fn_err = true
		fn_err_msg = "[x] Error (FILE:${filename}|L#${line_count}), Invalid Syntax. Missing opening parathensis '('\r\n"
	}

	if fn_err == true {
		// list errs and exit
		print(fn_err_msg)
		return
	}
}

pub fn exec_fn(file_fn_name string, fn_args []string, socket_t bool, mut socket net.TcpConn, mut wx WockyFX) {
	match file_fn_name {
		wockyfx.wfx_fns[0] { // Sleep
			wockyfx.wfx_sleep(fn_args[0].int())
		} 
		wockyfx.wfx_fns[1] { // Clear
			if socket_t == true {
				wockyfx.wfx_clear_sock(mut socket)
			} else {
				wockyfx.wfx_clear()
			}
		}
		wockyfx.wfx_fns[2] { // get_args()
			
		}
		wockyfx.wfx_fns[3] { // output_wrfx()
			// check for arg amount 
			if socket_t == true {
				wockyfx.wfx_output_wrfx_sock(get_str_between(fn_args[0], "\"", "\""), mut socket)
			} else {
				wockyfx.wfx_output_wrfx(get_str_between(fn_args[0], "\"", "\""))
			}
		}
		wockyfx.wfx_fns[4] { // print_text
			if socket_t == true {
				socket.write_string(replace_code(get_str_between(fn_args[0], "\"", "\""))) or { 0 }
			} else {
				print_data := get_str_between(fn_args[0], "\"", "\"")
				fixed_data := replace_code(print_data)
				print(fixed_data)
			}
		}
		wockyfx.wfx_fns[5] { // place_text
			if socket_t == true {
				wockyfx.wfx_place_text_sock(fn_args[0], fn_args[1], replace_code(get_str_between(fn_args[2], "\"", "\"")), mut socket)
			} else {
				wockyfx.wfx_place_text(fn_args[0], fn_args[1], replace_code(get_str_between(fn_args[2], "\"", "\"")))
			}
		}
		wockyfx.wfx_fns[6] { // list_text
			if socket_t == true {
				print_data := get_str_between(fn_args[2], "\"", "\"")
				fixed_data := socket_replace_code(print_data, mut wx)
				wockyfx.wfx_list_text_sock(fn_args[0], fn_args[1], fixed_data, mut socket)
			} else {
				print_data := get_str_between(fn_args[2], "\"", "\"")
				fixed_data := socket_replace_code(print_data, mut wx)
				wockyfx.wfx_list_text(fn_args[0], fn_args[1], fixed_data)
			}
		}
		wockyfx.wfx_fns[7] { // hide_cursor
			if socket_t == true {
				wockyfx.wfx_hide_cursor_sock(mut socket)
			} else {
				wockyfx.wfx_hide_cursor()
			}
		}
		wockyfx.wfx_fns[8] { // show cursor
			if socket_t == true {
				wockyfx.wfx_show_cursor_sock(mut socket)
			} else {
				wockyfx.wfx_show_cursor()
			}
		}
		wockyfx.wfx_fns[9] {
			if socket_t == true {
				wockyfx.wfx_slow_place_text_sock(fn_args[0], fn_args[1], replace_code(get_str_between(fn_args[2], "\"", "\"")), mut socket)
			} else {
				wockyfx.wfx_slow_place_text(fn_args[0], fn_args[1], replace_code(get_str_between(fn_args[2], "\"", "\"")))
			}
		}
		wockyfx.wfx_fns[10] {
			if socket_t == true {
				wockyfx.wfx_set_term_size_sock(fn_args[0], fn_args[1], mut socket)
			} else {
				wockyfx.wfx_set_term_size(fn_args[0], fn_args[1])
			}
		}
		wockyfx.wfx_fns[11] {
			if socket_t == true {
				wockyfx.wfx_change_term_title_sock(get_str_between(fn_args[0], "\"", "\""), mut socket)
			} else {
				wockyfx.wfx_change_term_title(get_str_between(fn_args[0], "\"", "\""))
			}
		}
		wockyfx.wfx_fns[12] {
			if socket_t == true {
				wockyfx.wfx_move_cursor_sock(fn_args[0], fn_args[1], mut socket)
			} else {
				wockyfx.wfx_move_cursor(fn_args[0], fn_args[1])
			}
		}
		else {
			// Dont Need
		}
	}
}

pub fn grab_fn_args(line string) []string {
	return get_str_between(line, "(", ")").split(",")
}

pub fn get_str_between(t string, start string, end string) string {
	mut new_str := ""
	mut ignore := true // ignore current text
	for i, letter in t {
		c := letter.ascii_str()
		if c == start && ignore == true {
			ignore = false
		} else if c == end && ignore == false {
			return new_str
		} else if ignore == false {
			new_str += c
		}
	}
	return new_str
}

pub fn replace_code(line string) string {
	mut fix := line.replace("{Default}", config.Default)
	fix = fix.replace("{Black}", config.Black)
	fix = fix.replace("{Red}", config.Red)
	fix = fix.replace("{Green}", config.Green)
	fix = fix.replace("{Yellow}", config.Yellow)
	fix = fix.replace("{Blue}", config.Blue)
	fix = fix.replace("{Purple}", config.Purple)
	fix = fix.replace("{Cyan}", config.Cyan)
	fix = fix.replace("{Light_Grey}", config.Light_Grey)
	fix = fix.replace("{Dark_Grey}", config.Dark_Grey)
	fix = fix.replace("{Light_Red}", config.Light_Red)
	fix = fix.replace("{Light_Green}", config.Light_Green)
	fix = fix.replace("{Light_Yellow}", config.Light_Yellow)
	fix = fix.replace("{Light_Blue}", config.Light_Blue)
	fix = fix.replace("{Light_Purple}", config.Light_Purple)
	fix = fix.replace("{White}", config.White)
	fix = fix.replace("{Default_BG}", config.Default_BG)
	fix = fix.replace("{Black_BG}", config.Black_BG)
	fix = fix.replace("{Red_BG}", config.Red_BG)
	fix = fix.replace("{Green_BG}", config.Green_BG)
	fix = fix.replace("{Yellow_BG}", config.Yellow_BG)
	fix = fix.replace("{Purple_BG}", config.Purple_BG)
	fix = fix.replace("{Cyan_BG}", config.Cyan_BG)
	fix = fix.replace("{Light_Gray_BG}", config.Light_Gray_BG)
	fix = fix.replace("{Dark_Gray_BG}", config.Dark_Gray_BG)
	fix = fix.replace("{Light_Red_BG}", config.Light_Red_BG)
	fix = fix.replace("{Light_Green_BG}", config.Light_Green_BG)
	fix = fix.replace("{Light_Yellow_BG}", config.Light_Yellow_BG)
	fix = fix.replace("{Light_Blue_BG}", config.Light_Blue_BG)
	fix = fix.replace("{Light_Purple_BG}", config.Light_Purple_BG)
	fix = fix.replace("{Light_Cyan_BG}", config.Light_Cyan_BG)
	fix = fix.replace("{White_BG}", config.White_BG)
	fix = fix.replace("{NEWLINE}", "\r\n")
	fix = fix.replace("{BOL}", "\r")
	return fix
}

pub fn socket_replace_code(line string, mut wx wockyfx.WockyFX) string {
	mut new := replace_code(line)
	new = new.replace("{ONLINEUSERS}", wx.online_users)
	new = new.replace("{LASTCMD}", wx.fcmd)
	return "${new}"
}