module utilities

import os
import rand

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

pub fn create_random_str(c int) string {
    chars := "qwertyuiopasdfghjklzxcvbnm1234567890-=[]\;',./`~!@#$%^&*()_+{}|:\"<>?QWERTYUIOPASDFGHJKLZXCVBNM"
    mut new_str := ""
    for i in 0..c {
        random_num := rand.int_in_range(0, chars.len) or { 0 }
        new_str += chars[random_num].ascii_str()
    }
    return new_str
}