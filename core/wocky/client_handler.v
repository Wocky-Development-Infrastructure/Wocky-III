module wocky

import os
import io
import net
import time

import core
import auth
import crud
import config
import wocky
import utilities
import term_control
import attack_system
import wockyfx

import commands // List of Commands


pub fn connection_handler(mut socket net.TcpConn, mut w wocky.Wocky) { 
	mut reader := io.new_buffered_reader(reader: socket)
	mut buffer := core.Buffer{}
	user_addr := socket.peer_addr() or { return } // This should almost never return an err
	user_ip := "${user_addr}".replace("[::ffff:","").split("]:")[0]
	user_port := "${user_addr}".split("]:")[1]
	if wockyfx.check_for_wfx_file("upon_connect") && wockyfx.check_for_wfx_data("upon_connect") {
		wockyfx.wockyfx(mut w.wx, "upon_connect")
	}

	mut username := ""
	mut password := ""

	if wockyfx.check_for_wfx_file("username_login") && wockyfx.check_for_wfx_file("password_login") {
		wockyfx.wockyfx(mut w.wx, "username_login")
		username = reader.read_line() or { "" }
		wockyfx.wockyfx(mut w.wx, "password_login")
		password = reader.read_line() or { "" }
	} else {
		socket.write_string("${config.Red}Username: ${config.Default}") or { 0 }
		username = reader.read_line() or { "" }
		socket.write_string("${config.Red}Password: ${config.Black}") or { 0 }
		password = reader.read_line() or { "" }
		socket.write_string("${config.Default}") or { 0 }
	}

	// Have to do a auth check here with the username and password later
	mut login_check, user_info := auth.login(username, password, user_ip, mut w.sqlconn)
	if login_check == 0 {
		username = ""
		password = ""
		socket.write_string("${config.Clear}${config.Red}[x] Error, No user found.....! exiting....") or { 0 }
		time.sleep(3*time.second)
		socket.close() or { return }
	} else if login_check == -1 {
		username = ""
		password = ""
		socket.write_string("${config.Clear}${config.Red}[x] Error, Invalid username or password.....! exiting....") or { 0 }
		time.sleep(3*time.second)
		socket.close() or { return }
	}

	if username == "" && password == "" {
		socket.close() or { return }
	}

	w.clients.add_session(username, mut socket, user_ip, user_port)
	if wockyfx.check_for_wfx_cmd("home") {
		wockyfx.wockyfx(mut w.wx, "home")
	} else {
		socket.write_string("Welcome to Wocky III\r\n") or { 0 }
	}
	println("${config.Green}[${utilities.current_time()}][+]${config.Default} User succesfully logged in. ${username} | ${user_ip}")
	println("${config.Green}[${utilities.current_time()}][+]${config.Default} Users Connected: ${w.clients.count}")

	command_handler(mut socket, mut &w, user_info)
}

pub fn command_handler(mut socket net.TcpConn, mut w wocky.Wocky, db_user_info map[string]string) {
	mut username, ip, port := w.clients.get_session_info(mut socket)
	mut buffer := core.Buffer{}
	mut reader := io.new_buffered_reader(reader: socket)
	// Grab all commands
	all_commands := wockyfx.get_all_cmds()
	mut input_cmd := ""
	for {
		// WockyFX Feature. Detecting a hostname file or use default hostname
		if wockyfx.check_for_wfx_file("hostname") && wockyfx.check_for_wfx_data("hostname") {
			wockyfx.wockyfx(mut w.wx, "hostname")
		} else {
			socket.write_string("[Wocky@NET]~ $ ") or { 
				w.clients.remove_session(mut socket)
				socket.close() or { return }
				return 
			}
		}
		// Grabbing input or disconnecting user!
		input_cmd = reader.read_line() or { 
			w.clients.remove_session(mut socket)
			socket.close() or { return }
			return
		}
		
		// Command Handling
		if input_cmd.replace("\r\n", "").len > 2 {
			buffer.parse(input_cmd)
			w.wx.add_buffer_info(buffer.full_cmd, buffer.cmd, buffer.cmd_args)

			if buffer.cmd == "attack" {
				// Do Attack Bullshit
				if wockyfx.check_for_wfx_cmd("attack") && wockyfx.check_for_wfx_cmd_data("attack") {
					w.wx.set_file("attack")
					mut max_arg, max_arg_err := wockyfx.check_for_max_arg(mut w.wx)
					if buffer.cmd_args.len < max_arg {
						wockyfx.wfx_parse_callback(mut w.wx, "attack", "set_arg_err_msg")
					} else {
						mut api_names, api_urls/*, api_maxtime, api_conn*/ := crud.read_apis_with_method_alt(buffer.cmd_args[4])
						t := attack_system.send_api_attack(buffer.cmd_args[1], buffer.cmd_args[2], buffer.cmd_args[3], buffer.cmd_args[4], db_user_info, mut w.sqlconn, api_names, api_urls)
						wockyfx.wockyfx(mut w.wx, "attack")
						// socket.write_string(t) or { 0 }
					}
				}
			} else {
				// Loop throught commands
				mut cmd_found := false
				for i, cmd in all_commands {
					if buffer.cmd == cmd {
						cmd_found = true
						wockyfx.wockyfx(mut w.wx, buffer.cmd)
					}
				}

				if cmd_found == false {
					wockyfx.wockyfx(mut w.wx, "invalid")
				}
			}
		}
	}

}