module wockyfx

import os
import config

pub fn check_for_wfx_file(filename string) bool {
	if os.exists("${config.wfx_path}${filename}.wfx") {
		return true
	}
	return false
}

pub fn check_for_wfx_cmd(filename string) bool {
	if os.exists("${config.wfx_path}${filename}_cmd.wfx") {
		return true
	}
	return false
}

pub fn get_all_cmds() []string {
	all_files := os.ls("${config.wfx_cmd_path}") or { [''] }
	mut all_commands := []string
	for i, file in all_files {
		if file.ends_with("_cmd.wfx") {
			all_commands << file.replace("_cmd.wfx", "")
		}
	}
	return all_commands
}

pub fn check_for_wfx_cmd_data(filename string) bool {
	mut file := os.read_file("${config.wfx_cmd_path}${filename}_cmd.wfx") or { "" }
	if file == "" || file.len == 0 {
		return false
	}
	return true
}

pub fn check_for_wfx_data(filename string) bool {
	mut file := os.read_file("${config.wfx_path}${filename}.wfx") or { "" }
	if file == "" || file.len == 0 {
		return false
	}
	return true
}

pub fn get_callback_code(function string, file_data []string) (int, []string) {
	mut new_code := []string
	for i, line in file_data {
		if line != "" {
			if line.starts_with(function) {
				if line.contains("(fnc() => {") {} else { return 0, [''] }
				mut start_here := i+1
				for new_line in start_here..file_data.len {
					if file_data[new_line] == "});" || file_data[new_line].contains("});") {
						return 1, new_code
					} else {
						new_code << file_data[new_line].trim_space()
					}
				}
			}
		}
	}
	return 0, ['']
}

pub fn check_for_max_arg(filepath string) (int, string) {
	file_data := os.read_lines(filepath) or { [''] }
	mut new_code := []string

	// Info from file
	mut max_arg := 0
	mut max_arg_err := ""

	// Check points for the loop
	mut set_max := false
	mut set_err_msg := false

	for i, line in file_data {
		if line != "" {
			if line.starts_with("set_max_arg") {
				max_arg = get_str_between(line, "(", ")").int()
				set_max = true
				if file_data[i+1].starts_with("set_arg_err_msg") {
					arg := get_str_between(file_data[i+1], "(", ")")
					max_arg_err = get_str_between(arg, "\"", "\"")
					set_err_msg = true
				}
			} else {
				new_code << line
			}
		} else {
			new_code << line
		}
	}
	if set_max == true && set_err_msg == false {
		println("[x] Error, Must use set_arg_err_msg(\"\"); in order to use set_max_arg(c);!")
		return max_arg, max_arg_err
	}
	// file_data = new_code
	return max_arg, max_arg_err
}

pub fn char_count(str string, cha string) int {
	mut char_count := 0
	for i, ch in str {
		c := ch.ascii_str()
		if c == cha {
			char_count++
		} 
	}
	return char_count
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
	return new_str //, t.replace(new_str, "")
}

pub fn get_str_between_alt(t string, pos int, start string, end string) string {
	mut new_str := ""
	mut ignore := true // ignore current text
	mut n := 0
	for i, letter in t {
		c := letter.ascii_str()
		if c == start && ignore == true && n == pos {
			n++
			ignore = false
		} else if c == end && ignore == false {
			return new_str
		} else if ignore == false {
			new_str += c
		}
	}
	return new_str //, t.replace(new_str, "")
}