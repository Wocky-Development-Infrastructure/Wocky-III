/********************************************
*                                           *
*     Wocky III | The Ultimate Version      *
*                                           *
*  @title: Wocky III                        *
*  @author: Erupt, Lamp                     *
*  @since: 4/7/22                           *
*                                           *
********************************************/
import os
import rand
import mysql

import core
import core.config
import core.wocky
import core.utilities
import core.term_control
import core.wockyfx

fn main() {
	mut t := core.Terminal{}
	config.check_for_configuration()
	config.configure_design_info(mut t)
	mut w := wocky.Wocky{sqlconn: &mysql.Connection{
		username: "root",
		dbname: "wocky3"
	}, terminal: &t, clients: &core.Clients{}, wx: wockyfx.start_session()}
	mut args := os.args.clone()
	for i, arg in args {
		match arg {
			"-port" {
				w.client_port = args[i+1].int()
			}
			"-bot_port" {
				w.bot_port = args[i+1].int()
			}
			"-sqlpw" {
				w.sqlconn.password = args[i+1]
			}
			"-sqlhost" {
				w.sqlconn.host = args[i+i]
			} else {

			}
		}
	}

	if w.bot_port == 0 {
		println("${config.Red}[${utilities.current_time()}][x]${config.Default}  Error, No bot port was provided. The bot system did not start....")
	}

	if w.sqlconn.password == "" {
		println("${config.Red}[${utilities.current_time()}][x]${config.Default}  Error, No MySQL password provided. Using text file databases....!")
	}

	if w.sqlconn.host.len == 0 {
		w.sqlconn.host = "localhost"
	}
	
	go wocky.start_wocky(mut &w)
	for {
		input := os.input(">>> ")
		config.configure_design_info(mut t)
	}
}