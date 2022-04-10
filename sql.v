/*
	This is a debugging script to test functions
*/
import os

import mysql
import core.crud

fn main() {
	mut sql := mysql.Connection{
		host: "localhost",
		username: "root",
		password: "faggoted343#",
		dbname: "wocky3"
	}

	sql.connect() or {
		println("error")
		return
	}

	create_user("test", "tnthh", "1.1.1.1", mut sql)
	read_apis_with_method("HOME-TRC", mut sql)
}

pub fn create_user(user string, password string, ip string, mut conn mysql.Connection) {
	conn.connect() or { println("[X] Error, Unable to connect to MySQL!") }
    resp := conn.query('INSERT INTO users VALUES(0, \"${user}\", \"${ip}\", SHA1(\"${password}\"), 0, 0, 0, 0, 0, "0/00/0000")') or { panic("[x] Error, Unable to interact with MySQL!") }
	conn.close()
}

pub fn read_apis_with_method(method string, mut conn mysql.Connection) ([]string, []string/*, []string, []string*/) {
	conn.connect() or { println("[X] Error, Unable to connect to MySQL!") }
	resp := conn.query('SELECT * FROM apis') or { panic("[x] Error, Unable to interact with MySQL!") }
	mut api_names := []string
	mut api_urls := []string

	for i, info in resp.maps() {
		if info['api_methods'].contains(method) {
			if info['api_toggle'].int() == 1 {
				api_names << info['api_name']
				api_urls << info['api_url']
				// api_maxtime << info['api_maxtime']
				// api_maxconn << info['api_maxconn']
				// api_info['api_funnels'] << info['api_funnels'] // Use for later
			}
		}
	}
	
	unsafe {
		resp.free()
	}
	conn.close()
	return api_names, api_urls //, api_maxconn, api_maxconn
}