module config

import os
import x.json2

import core
import config
import utilities

pub fn check_for_configuration() {
	if os.exists(os.getwd() + "/assets/wocky.json") == true {
		println("${config.Red}[${utilities.current_time()}][x]${config.Default} Error, Configuration file missing!\r\nExpected Path: ${config.Green}${os.getwd()}/assets/wocky.json${config.Default}")
		exit(0)
	}
}

pub fn configure_net_info(mut t core.Terminal) {
	check_for_configuration()
	config := os.read_file(os.getwd() + "/assets/wocky.json") or { return }

	mut file_settings := json2.raw_decode(config) or { 0 }
	json_data := file_settings.as_map()

	
}