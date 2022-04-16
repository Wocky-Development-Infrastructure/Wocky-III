import os
import core.wockyfx


fn main() {
	mut wx := wockyfx.WockyFX{online_users: "root\nblueberry\nbrizy\nLamp\nVizionzx\nsocial\nfrosts\nmalware"}

	wockyfx.wockyfx(mut wx, os.args[1])

}