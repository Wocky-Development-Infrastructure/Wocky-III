module portscan

import net

pub fn portscan(ip string){

	for port := 0; port < 65535; port++ {
		mut open_port_count := 0
		mut closed_port_count := 0
		mut conn := net.dial_tcp('${ip}:${port}') or {
			closed_port_count += 1
			continue
		}
		println('\x1b[31m[OPEN] \x1b[34m ${port} \x1b[39m \n')
		open_port_count += 1
		conn.close() or { return }
	}
	println("$open_port_count open ports and $closed_port_count closed ones.")
}

