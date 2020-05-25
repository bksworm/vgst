module main

import time
import gst

const (
	gst_line = 'appsrc name=line  stream-type=0 format=time is-live=true do-timestamp=true ' +
		' !  video/x-raw,width=320,height=240,format=GRAY8,framerate=25/1 ' + '!  videoconvert ! video/x-raw,format=I420 ' +
		' ! vp9enc !  matroskamux ! filesink location=appsrc.mkv'
)

fn gen_line(h, w int, appsrc &gst.Element) {
	mut frame := []byte{}
	for y := 0; y < h; y++ {
		shift := y * w
		for x := 0; x < h; x++ {
			frame[x + shift] = x % 255
		}
		appsrc.push_buffer(frame)
		time.sleep_ms(80) // ~frame per second
	}
}

fn run(ml &gst.GMainLoop) {
	ml.run()
}

fn main() {
	p := gst.parse_launch(gst_line) or {
		println(err)
		return
	}
	defer {
		p.unref()
	}
	e := p.get_by_name('line') or {
		println(err)
		return
	}
	ml := gst.new_main_loop()
	go run(ml)
	p.set_state(gst.StatePlaying)
	gen_line(240, 320, e)
	ml.quit()
	println('End of record')
}
