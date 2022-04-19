module tools

import net

pub fn portscan(ip string) []int {
	mut ports := []int{}

	for port := 0; port < 65535; port++ {
		mut conn := net.dial_tcp('${ip}:${port}') or { continue }
		ports << port
		conn.close() or { continue }
	}
	return ports
}
