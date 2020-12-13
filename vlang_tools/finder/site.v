module finder

import os
// import json


struct Site{
	name 	string
	path 	string
	pub mut:
		images	map[string]Image
		pages	map[string]Page
		errors  []SiteError

}

pub enum SiteErrorCategory { duplicateimage duplicatepage}
struct SiteError {
	path 	string
	error	string
	cat 	SiteErrorCategory
}

//remember the image, so we know if we have duplicates
fn (mut site Site) remember_image(path string, name string){
	mut namelower := name_fix(name)
	mut pathfull := os.join_path(path, name)
	// now remove the root path
	pathfull = pathfull[site.path.len+1..]
	// println( " - Image $pathfull" )
	if namelower in site.images {
		//error there should be no duplicates
		mut duplicatepath := site.images[namelower].path
		site.errors << SiteError{path:pathfull, error:"duplicate image $duplicatepath", cat:SiteErrorCategory.duplicateimage}
	}else{
		site.images[namelower] = Image({ path: pathfull})
		image := site.images[namelower]
		// println(image)
	}
}

fn (mut site Site) remember_page(path string, name string){

	mut pathfull := os.join_path(path, name)
	pathfull = pathfull[site.path.len+1..]
	mut namelower := name_fix(name)
	// println( " - Page $pathfull" )

	if namelower in site.pages {
		//error there should be no duplicates
		mut duplicatepath := site.pages[namelower].path
		site.errors << SiteError{path:pathfull, error:"duplicate page $duplicatepath", cat:SiteErrorCategory.duplicatepage}
	}else{
		site.pages[namelower] = Page({ path: pathfull})
		page := site.pages[namelower]
		// println(page)
	}

}


fn (mut site Site) process_files(path string) ? {
	// mut ret_err := ''
	items := os.ls(path)?

	for item in items {
		if os.is_dir(os.join_path(path, item)) {
			mut basedir := os.file_name(path)
			if basedir.starts_with(".") {continue}
			if basedir.starts_with("_") {continue}		
			site.process_files(os.join_path(path, item))
			continue
		} else {
			if item.starts_with(".") {continue}
			if item.starts_with("_") {continue}
			//for names we do everything case insensitive
			mut itemlower := item.to_lower()
			mut ext := os.file_ext(itemlower)			
			if ext != "" {
				//only process files which do have extension
			 	ext2 := ext[1..]

				if ext2 == "md" {
					site.remember_page(path,item)
				}

				if ext2 in ["jpg","png"] {
					site.remember_image(path,item)
				}	
			}
		}
	}
}

pub fn (mut site Site) process() {
	for key in site.pages.keys(){
		site.pages[key].process(site)
	}	
	for key in site.images.keys(){
		site.images[key].process(site)
	}		
}

pub fn (mut site Site) page_get(name string) Page{	
	mut namelower := name_fix(name)
	if namelower in site.pages {
		return site.pages[namelower]
	}
	panic("Could not find page $namelower in site ${site.name}")
}

pub fn (mut site Site) page_exists(name string) bool{	
	mut namelower := name_fix(name)
	// println(site.pages.keys())
	if namelower in site.pages {
		return true
	}
	return false
}

pub fn (mut site Site) image_get(name string) Image{	
	mut namelower := name_fix(name)
	if namelower in site.images {
		return site.images[namelower]
	}
	panic("Could not find image $namelower in site ${site.name}")
}

pub fn (mut site Site) image_exists(name string) bool{	
	mut namelower := name_fix(name)
	if namelower in site.images {
		return true
	}
	return false
}