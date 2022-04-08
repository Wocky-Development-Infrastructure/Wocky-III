module wockyfx

import core.wocky

pub struct WockyFX {
	pub mut:
		current_output	string
}

pub fn (mut wx WockyFX) add_ui(c string) {
	wx.current_output = c
}

pub fn (mut wx WockyFX) make_ui() string {

}