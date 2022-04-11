module auth

import mysql
import crypto.sha1

import crud

/*
This login() function returns 1 on success
0 on 'No user found'
and -1 on invalid username or password
*/
pub fn login(username string, password string, user_ip string, mut sql mysql.Connection) (int, map[string]string) {
	mut user_info := map[string]string

	mut alt_c := crud.AltCrud{username: "root"}
	mut info := crud.read_user_alt(mut alt_c)
	user_info['id'] = info['id'].str()
	user_info['username'] = info['username']
	user_info['ip'] = info['ip']
	user_info['password'] = info['password']
	user_info['plan'] = info['plan']
	user_info['maxtime'] = info['maxtime']
	user_info['conn'] = info['conn']
	user_info['ongoing'] = info['ongoing']
	user_info['admin'] = info['admin']
	user_info['expiry'] = info['expiry']

	println(user_info)
	
	encrypted_pw := sha1.sum(password.bytes()).hex()
	
	if user_info['username'] == username {
		if user_info['password'] == encrypted_pw {
			return 1, user_info
		} else {
			return -1, user_info
		}
	} else {
		return -1, user_info
	}
}