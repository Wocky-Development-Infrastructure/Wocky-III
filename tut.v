import os
import core.wockyfx


fn main() {
	mut wx := wx.parse_wfx{online_users: "root\nblueberry\nbrizy\nLamp\nVizionzx\nsocial\nfrosts\nmalware"}
	args := os.args.clone()
	if args.len < 2 {
		println("[x] Error, Invalid argument. Usage: ${args[0]} <file.wfx>")
		exit(0)
	}
	wx.parse_wfx(mut wx, args[1])

	// println(wockyfx.get_callback_code("attack", "set_arg_err_msg"))
}