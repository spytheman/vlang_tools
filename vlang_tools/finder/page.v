module finder

import os
// import json

pub enum PageStatus { unknown ok error }
struct Page {
	path 	string
	state 	PageStatus
	errors []PageError
	nrtimes_inluded int
	nrtimes_linked 	int
}

struct PageError {
	line	string
	linenr 	int
	error	string
}


//process the markdown content and include other files, find links, ...
pub fn (mut page Page) process(site Site){
	mut path := os.join_path(site.path,page.path)
	contents := os.read_file(path) or {
		println('Failed to open $path')
		return
	}

	for line in contents.split_into_lines() {
			// println (line)
		}	

}
