module config

import os
import x.json2

import core
import config
import utilities

pub fn check_for_configuration() {
	if os.exists(os.getwd() + "/assets/wocky.json") == false {
		println("${config.Red}[${utilities.current_time()}][x]${config.Default} Error, Configuration file missing!\r\nExpected Path: ${config.Green}${os.getwd()}/assets/wocky.json${config.Default}")
		exit(0)
	}
}

pub fn configure_design_info(mut t core.Terminal) {
	check_for_configuration()
	config := os.read_file(os.getwd() + "/assets/wocky.json") or { return }

	mut json_data := json2.raw_decode(config) or { 0 }
	file_settings := json_data.as_map()

	/*
		Converting fields from 'Design' Structure
	*/

	// Converting 'Design' JSON STRUCT to `map`
	design_json_settings := json2.raw_decode(file_settings['Design'].str()) or { 0 }
	design_settings := design_json_settings.as_map()

	// Converting 'Terminal' JSON to `map`
	terminal_json_settings := json2.raw_decode(design_settings['Terminal'].str()) or { 0 }
	terminal_settings := terminal_json_settings.as_map()

	t.size = terminal_settings['size'].str()
	t.title = terminal_settings['title'].str()

	// Converting 'Hostname' JSON Structure to 'map'
	hostname_json_settings := json2.raw_decode(design_settings['Hostname'].str()) or { 0 }
	hostname_settings := hostname_json_settings.as_map()

	t.hostname = hostname_settings['hostname'].str()
	t.hostname_position = hostname_settings['hostname_position'].str()
	t.cli_cursor = hostname_settings['cli_cursor'].str()
	
	// Converting 'CNC' JSON Structure to 'map'
	cnc_json_settings := json2.raw_decode(design_settings['CNC'].str()) or { 0 }
	cnc_settings := cnc_json_settings.as_map()

	t.cnc_output_position = cnc_settings['cnc_output_position'].str()
	t.max_output_rows = cnc_settings['max_output_rows'].int()
	t.max_output_width = cnc_settings['max_output_width'].int()
	t.last_cmd_output = cnc_settings['last_cmd_output'].str()
	t.cmd_response_output = cnc_settings['cmd_response_output'].str()

	// Converting 'online_list' JSON Structure to 'map'
	cnc_list_settings := json2.raw_decode(design_settings['online_list'].str()) or { 0 }
	onlinelist_settings := cnc_list_settings.as_map()

	t.output_toggle = onlinelist_settings['output_toggle'].bool()
	t.output_position = onlinelist_settings['output_position'].str()
	
}