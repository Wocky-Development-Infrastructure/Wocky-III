module wocky

import os
import io
import net
import time


import wocky
import term_control
import utilities


pub fn connection_handler(mut socket net.TcpConn, mut w wocky.Wocky) { 
	mut reader := io.new_buffered_reader(reader: socket)
	mut ui_settings := wocky.Terminal{}
	mut buffer := wocky.Buffer{}
	user_addr := socket.peer_addr() or { return } // This should almost never return an err
	user_ip := "${user_addr}".replace("[::ffff:","").split("]:")[0]
	user_port := "${user_addr}".split("]:")[1]
	
	socket.write_string("${term_control.Red}Username: ${term_control.Default}") or { 0 }
	username := reader.read_line() or { "" }
	socket.write_string("${term_control.Red}Password: ${term_control.Default}") or { 0 }
	password := reader.read_line() or { "" }

	// Have to do a auth check here with the username and password later
	// mut login_check := auth.login(username, password, user_ip, mut w)
	// if login_check == 0 {
	// 	socket.write_string("${term_control.Clear}${term_control.Red}[x] Error, Invalid information provided! exiting....")
	// 	time.sleep(2*time.second)
	// 	socket.close() or { return }
	// }

	socket.write_string("Welcome to Wocky III\r\n") or { 0 }
	println("${term_control.Green}[${utilities.current_time()}][+]${term_control.Default} User succesfully logged in. ${username} | ${user_ip}")

	// Log User to CLIENTS SESSIONS

	command_handler(mut socket, mut &w, mut &ui_settings, mut buffer, user_ip)
}

pub fn command_handler(mut socket net.TcpConn, mut w wocky.Wocky, mut ui_settings wocky.Terminal, mut buffer wocky.Buffer, user_ip string) {
	mut reader := io.new_buffered_reader(reader: socket)
	for {
		socket.write_string("[Wocky@NET]~ $ ") or { 0 }
		input_cmd := reader.read_line() or { "" }
		if input_cmd.replace("\r\n", "").len > 2 {
			buffer.parse(input_cmd)

			match buffer.cmd {
				"help" {
					socket.write_string("working\r\n") or { 0 }
				} else {
					socket.write_string("[x] Command not found!\r\n") or { 0 }
				}
			}
		}
	}

}