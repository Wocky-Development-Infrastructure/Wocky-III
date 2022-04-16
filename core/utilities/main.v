module utilities

import os

pub fn current_time() string {
    return (os.execute("sudo timedatectl set-timezone America/New_York; date +\"%m/%d/%y-%R\"").output).trim_space()
}

pub fn create_empty_str(char_count int) string {
    mut new_str := ""
    for i in 0..char_count {
        new_str += " "
    }
    return new_str
}