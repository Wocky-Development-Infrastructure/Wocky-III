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
	
	// mut api_names, api_urls, api_maxtime, api_maxconn := crud.read_apis_with_method("kill-all", mut sql)
	
	// mut user_info := crud.read_user("root", mut sql)
	// println("${user_info}")
}