import finder
fn main() {

	mut f := finder.get()

	println("start")
	// f.load("test","~/code/github/threefoldtech/info_tftech")
	// f.load("/tmp")
	f.load("test","testcontent/site1")

	// println(f.sites["test"])

	f.process()

	//argument will be comeo lowercase and remove '.md' at end
	mut page := f.page_get("teal_Organization_intro.md")
	println(page) 

	mut image := f.image_get("3bot_Dashboard.png")
	println(image) 

	

}