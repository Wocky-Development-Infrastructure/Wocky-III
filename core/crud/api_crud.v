module crud

import os
import mysql

pub fn create_api(api string, mut sql mysql.Connection)  {

}

pub fn read_api(api string, mut conn mysql.Connection) map[string]string {
	conn.connect() or { println("[x] Error, Unable to connect to MySQL!") }
	resp := conn.query('SELECT * FROM apis WHERE api_name=\'${api}\'') or { panic("[x] Error, Unable to interact with MySQL!") }

	mut api_info := map[string]string
	for i, info in resp.maps() {
		if info['api_name'] == api {
			api_info['id'] = info['id']
			api_info['api_name'] = info['api_name']
			api_info['api_url'] = info['api_url']
			api_info['api_maxtime'] = info['api_maxtime']
			api_info['api_maxconn'] = info['api_maxconn']
			api_info['api_methods'] = info['api_methods']
			api_info['api_funnels'] = info['api_funnels']
			api_info['api_toggle'] = info['api_toggle']
		}
	}
	resp.free()
	conn.close()
	return api_info
}

pub fn read_apis_with_method(method string, mut conn mysql.Connection) ([]string, []string/*, []string, []string*/) {
	println("TEST")
	conn.connect() or { println("[x] Error, Unable to connect to MySQL!") }
	println("Here SQL 1")
	resp := conn.query('SELECT * FROM apis') or { panic("[x] Error, Unable to interact with MySQL!") }
	println("Here SQL 2")

	mut api_names := []string
	mut api_urls := []string
	mut api_maxtime := []string
	mut api_maxconn := []string

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
	
	println("Here SQL 3")
	unsafe {
		resp.free()
	}
	conn.close()
	return api_names, api_urls //, api_maxconn, api_maxconn
}

pub fn update_api(api string, mut sql mysql.Connection)  {

}

pub fn delete_api(api string, mut sql mysql.Connection)  {

}