module auth

import crypto.sha1
import crud
import wocky

pub fn login(username string, password string, user_ip string, mut w wocky.Wocky) int {
	mut user_info := crud.read_user(username, )
	encrypted_pw := sha1.sum(password.bytes()).hex()
}