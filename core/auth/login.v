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
	mut alt_c := crud.AltCrud{username: username}
	mut info_struct := crud.read_user_alt(mut alt_c)
	mut info := crud.struct_to_map(info_struct)
	
	encrypted_pw := sha1.sum(password.bytes()).hex()
	
	println("${info}\r\n${username} | ${password}")
	if info['username'] == username {
		if info['password'] == encrypted_pw {
			return 1, info
		} else {
			return -1, info
		}
	} else {
		return -1, info
	}
}