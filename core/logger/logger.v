module logger



import os
import time



pub fn log2file(file string, logg string) {
	mut fille := os.open_append(os.getwd + "/assets/logs/${file}.log") or { return }
	fille.write(logg.bytes()) or { 0 }
	fille.close()
}


pub fn loginlog(user string, pass string, ip string) {
	mut time := time.now()
	log2file("logins", "[$time][Attempted Info]: ${user} // ${pass} | ${ip}\n")
}


pub fn attack_log(user string, user_ip string, ip string, port string, duration int, method string) {
	mut time := time.now()
	log2file("attacks", "[$timee][Attack Info]: $user | ${user_ip} | $ip:$port $duration $method\r\n")
}

pub fn command_log(user string, command string) {
	mut time := time.now()
	log2file("cmds", "[$timee][Command Info]: $user just ran // $command\r\n")
}