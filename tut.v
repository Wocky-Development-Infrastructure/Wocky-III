import os

struct BlueBerry {

}

const (
	// adding variables here

	// const variables are READ-ONLY variables

	testing = "Lulzsec" // THIS VARIABLE IS ONLY READABLE. SINCE ITS A CONST VARIABLE
)

fn main() {
	// muttable and immutable

	// Immutable variable
	mut t := blueberry()
	println(t) // output: 'ggrwegreger'

}

// fn as def
pub fn blueberry() string {
	return "rggrwegreger"
}

