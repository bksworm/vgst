module gst

struct GMainLoop  {
	gl &C.GMainLoop
}

pub fn new_main_loop() &GMainLoop {
	cloop := C.g_main_loop_new(0, 0)
	return &GMainLoop{gl: cloop}
}

pub fn  (l GMainLoop) unref(){
	C.gst_object_unref(l.gl)
}

pub fn (l GMainLoop) run() {
	C.g_main_loop_run(l.gl)
}

pub fn (l GMainLoop) quit() {
	C.g_main_loop_quit(l.gl)
}

pub fn (l GMainLoop) is_runing() bool {
	cbool := C.g_main_loop_is_running(l.gl)
	return cbool == 1
}
