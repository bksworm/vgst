module gst

fn testsuite_begin(){
	init()
}

fn test_parse_launch_ok(){
	p := parse_launch("fakesrc ! fakesink") or {
		println(err)
		assert false
		return
	}
	defer {p.unref()}
	assert false ==  isnil(p)  
}

fn test_parse_launch_err(){
	parse_launch("fakesrc ! doo ! fakesink") or {
		//println(err)
		return
	}
	assert false  
}

fn test_get_by_name(){
	p := parse_launch("fakesrc ! fakesink name=right_name") or {
		println(err)
		assert false
		return
	}
	defer {p.unref()}
	
	e := p.get_by_name("right_name") or {
		println(err)
		assert false
		return	
	} 
	assert false ==  isnil(e)
}

fn test_get_by_name_err(){
	p := parse_launch("fakesrc ! fakesink name=right_name") or {
		println(err)
		assert false
		return
	}
	defer {p.unref()}
	
	p.get_by_name("wrong_name") or {
		//println(err)
		return	
	} 
	assert false 
}
