
module main

import gst

fn main() {
        p := gst.parse_launch('videotestsrc ! autovideosink') or {
                println(err)
                return
        }
        defer {
                p.unref()
        }
        ml := gst.new_main_loop()
        defer {
                ml.unref()
        }
        p.set_state(gst.StatePlaying)
        ml.run()
        println('hello world')
}
