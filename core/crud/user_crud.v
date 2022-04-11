module crud

import os
import mysql

pub fn create_user(user string, password string, ip string, mut conn mysql.Connection) {
    conn.connect() or { println("[X] Error, Unable to connect to MySQL!") }
    resp := conn.query('INSERT INTO users VALUES(0, \"${user}\", \"${ip}\", SHA1(\"${password}\"), 0, 0, 0, 0, 0, "0/00/0000")') or { panic("[x] Error, Unable to interact with MySQL!") }
	conn.close()
}

pub fn read_user(user string, mut conn mysql.Connection) ?map[string]string {
	conn.connect() or { println("[x] Error, Unable to connect to MySQL!") }
	mut resp := conn.query('SELECT * FROM users WHERE username=\'${user}\'') or { panic("[x] Error, Unable to interact with MySQL!") }

	mut row_info := map[string]string
	for i, info in resp.maps() {
		if info['username'] == user {
			row_info['id'] = info['id']
			row_info['username'] =  info['username']
			row_info['ip'] = info['ip']
			row_info['password'] = info['password']
			row_info['plan'] = info['plan']
			row_info['maxtime'] = info['maxtime']
			row_info['conn'] = info['conn']
			row_info['ongoing'] = info['ongoing']
			row_info['admin'] = info['admin'] 
			row_info['expiry'] = info['expiry']
		}
	}
	unsafe {
		resp.free()
	}
	conn.close()
	return row_info
}

[params]
struct InfoConfig {

}

pub fn update_user(user string, password string, ip string, mut conn mysql.Connection) {

}

pub fn delete_user(user string) {

}