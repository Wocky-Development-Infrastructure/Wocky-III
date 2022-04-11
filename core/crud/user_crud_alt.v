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
pub fn read_user_alt(mut a AltCrud) AltCrud {
	println(db_filepath)
	mut users := os.read_lines(db_filepath) or {
		println("[x] Error, Unable to find db....!")
		exit(0)
	}

	mut user_info := map[string]string

	for i, user in users {
		current_info := parse_line(user)
		if current_info[1] == a.username {
			a.id = current_info[0].int()
			a.username = current_info[1]
			a.ip = current_info[2]
			a.password = current_info[3]
			a.plan = current_info[4].int()
			a.maxtime = current_info[5].int()
			a.conn = current_info[6].int()
			a.ongoing = current_info[7].int()
			a.admin = current_info[8].int()
			a.expiry = current_info[9]
			return a
		}
	}
	return a
}

pub fn struct_to_map(a AltCrud) map[string]string {
	mut resp := map[string]string

	resp['id'] = a.id
	resp['username'] = a.username
	resp['ip'] = a.ip
	resp['password'] = a.password
	resp['plan'] = a.plan
	resp['maxtime'] = a.maxtime
	resp['conn'] = a.conn
	resp['ongoing'] = a.ongoing
	resp['admin'] = a.admin
	resp['expiry'] = a.expiry

	return resp
}