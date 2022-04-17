module logger

import os
import time

pub fn loginlog_t(user string, pass string, ip string) {
	mut time := time.now()
	println("[$time][Attempted Info]: ${user} // ${pass} | ${ip}\n")
}


pub fn attack_log_t(user string, user_ip string, ip string, port string, duration int, method string) {
	mut time := time.now()
	println("[$timee][Attack Info]: $user | ${user_ip} | $ip:$port $duration $method\r\n")
}

pub fn command_log_t(user string, command string) {
	mut time := time.now()
	println("[$timee][Command Info]: $user just ran // $command\r\n")
}