module logger

import logger

pub fn log_cmd(user_info map[string]string, fcmd string, args []string) {
	logger.send_cmd_log(user_info['username'], args)
	logger.command_log(user_info['username'], fcmd)
	logger.command_log_t(user_info['username'], args)
}

pub fn log_attack(user_info map[string]string, user_ip string, fcmd string, args []string) {
	logger.send_attack_log(user_info['username'], user_ip, args[1], args[2], args[3].int(), args[4])
	logger.attack_log(user_info['username'], user_ip, args[1], args[2], args[3].int(), args[4])
	logger.attack_log_t(user_info['username'], user_ip, args[1], args[2], args[3].int(), args[4])
}

pub fn log_login(username string, password string, user_ip string) {
	logger.send_login_log(username, password, user_ip)
	logger.loginlog(username, password, user_ip)
	logger.loginlog_t(username, password, user_ip)
}