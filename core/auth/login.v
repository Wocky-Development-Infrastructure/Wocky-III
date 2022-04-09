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
	mut user_info := crud.read_user(username, mut sql)
	// No user found error
	if user_info.len == 0 {
		return 0, user_info
	}
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