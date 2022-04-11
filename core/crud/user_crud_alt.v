module crud

import os

pub struct AltCrud {
	pub mut:
		id			int
		username	string
		ip			string
		password	string
		plan		int
		maxtime		int
		conn		int
		ongoing		int
		admin		int
		expiry		string
}

pub type Result = string | map[string]string | AltCrud

const db_filepath = os.getwd() + "/assets/db/users.db"

pub fn parse_line(line string) []string {
	return line.replace("('", "").replace("')", "").split("','")
}

pub fn create_user_alt(mut a AltCrud) Result {
	mut fd := os.open_append(db_filepath) or { 
		println("[x] Error, Unable to find or read db!")
		return ""
	}

	new_user_id := (os.read_lines(db_filepath) or { [''] }).len+1

	fd.write("('${new_user_id}','${a.username}','{${a.ip}','${a.password}','0','0','0','0','0','0/00/00'\n".bytes()) or {
		println("[x] Error, Unable to write to file!")
		return ""
	}

	fd.close()
	return ""
}

/*
	This function can return a string or a AltCrud Struct
	Example User:
		mut info := crud.read_user(AltCrud{username: "root"})
		if info.ip == "" {
			// catch error
		}
*/
pub fn read_user_alt(mut a AltCrud) map[string]string {
	println(db_filepath)
	mut users := os.read_lines(db_filepath) or {
		println("[x] Error, Unable to find db....!")
		exit(0)
	}

	mut user_info := map[string]string

	for i, user in users {
		current_info := parse_line(user)
		if current_info[1] == a.username {
			user_info['id'] = current_info[0]
			user_info['username'] = current_info[1]
			user_info['ip'] = current_info[2]
			user_info['password'] = current_info[3]
			user_info['plan'] = current_info[4]
			user_info['maxtime'] = current_info[5]
			user_info['conn'] = current_info[6]
			user_info['ongoing'] = current_info[7]
			user_info['admin'] = current_info[8]
			user_info['expiry'] = current_info[9]
			return user_info
		}
	}
	
	return user_info
}