module gst

pub struct Pipeline {
	e Element
}

fn init() { 
 C.x_gst_shim_init()
 }

pub fn parse_launch(pipelineStr string) ?&Pipeline {
	g_err :=  &C.GError(0) // a temporary hack meaning GError* g_err = 0

	e := C.gst_parse_launch(pipelineStr.str, &g_err)
	defer {C.g_clear_error(&g_err) }
	
	if isnil(g_err) == false {
		info := tos_clone(C.getErrorMsg(g_err))
		return error("create pipeline error: " + info )
	}

	p := &Pipeline{e: Element{ge: e}}

	return p
}

pub fn (p &Pipeline)unref() {
	C.gst_object_unref(p.e.ge)
}

pub fn (p &Pipeline) set_state(state int) {
	C.gst_element_set_state(p.e.ge, state)
}

fn (p &Pipeline) get_bus()  &Bus  {
	cbus := C.x_gst_pipeline_get_bus(p.e.ge)
	bus := &Bus{
		b: cbus,
	}
	return bus
}

pub fn (p &Pipeline) get_by_name(name string) ?&Element {
	ce := C.x_gst_bin_get_by_name(p.e.ge, name.str)
	if ce == 0 {
		return error("Element $name not found!")
	}

	e := &Element{
		ge: ce,
	}
	return e
}
