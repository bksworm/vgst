module gst


pub struct Element  {

mut:
	ge &C.GstElement
	callbackID u64
}


pub fn (e Element) name()  ?string {
	n := C.gst_object_get_name(e.ge)
	if n == 0 {
		return error("No name!")
	}
	s := tos_clone(n)
	C.g_free(n)
	return s
}

pub fn (e Element)unref() {
	C.gst_object_unref(e.ge)
}

struct Sample {
	data []byte
mut:	
	duration u64
}

pub fn (s Sample) free(){
 	s.data.free()	
}

pub fn(e Element) pull_sample(mut sample &Sample) ?&Sample {

	gst_sample := C.gst_app_sink_pull_sample(&C.GstAppSink(e.ge))
	if isnil(gst_sample) {
		return error("could not pull a sample from appsink")
	}
	defer {	C.gst_sample_unref(gst_sample)}

	gst_buffer := C.gst_sample_get_buffer(gst_sample)
	if isnil(gst_buffer) {
		return error("could not pull a sample from appsink")
	}
	
	mut mi := []byte{cap:sizeof(C.GstMapInfo)}	
	map_info := &C.GstMapInfo(mi.data) 
	if C.x_gst_buffer_map(gst_buffer, map_info) == 0 {
		return error("could not map gst_buffer")
	}
	defer {C.gst_buffer_unmap(gst_buffer, map_info)}
	
	cdata := C.x_gst_map_info_data(map_info)
	data_size := C.x_gst_map_info_size(map_info)
	//TODO: chage to strings.Builder ?
	sample.data.clear() 
	sample.data.push_many(cdata, data_size)
	sample.duration = C.x_gst_buffer_get_duration(gst_buffer)

	return sample
}

pub fn (e Element) push_buffer(b []byte) int {
	return C.x_gst_app_src_push_buffer(e.ge, b.data, b.len)
}

pub fn (e Element) is_eos() bool {
	cbool := C.gst_app_sink_is_eos(&C.GstAppSink(e.ge))
	return cbool == 1
}
