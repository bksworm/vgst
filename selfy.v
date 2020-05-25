module main

import time
import gst
import cli
import os
import strconv

const (

	gst_line = "v4l2src device=%s  ! video/x-raw,width=640,height=480 ! " +
		"tee name=t !  queue !  videoconvert ! video/x-raw,format=BGRA ! gtksink " +
		" t. ! queue !   jpegenc !  appsink name=%s"
    camera_name = "camera"		
)

fn take_pictures(n, skip int, appsrc &gst.Element) {
	sample := &gst.Sample{}

		//skip some frames
	  for x := 0; x < 25; x++ {
		  //we must get frames from gstreamer and destroy them
		  appsrc.pull_sample(sample, false) or {
		  println(err)
		  return
		  }
	
	  }	
		
	for y := 0; y < n; y++ {
		appsrc.pull_sample(sample, true) or {
			println(err)
			return
		}
		save_jpeg("./", y, sample)	
		//skip some frames
		for x := 0; x < skip; x++ {
			//we must get frames from gstreamer and destroy them
			appsrc.pull_sample(sample, false) or {
			println(err)
			return
			}
	
		}	
	}
}

fn save_jpeg(dir string, n int, s &gst.Sample,){
	file_name := os.join_path(dir, "test${n}.jpg")
	mut f := os.open_file(os.real_path(file_name), 'w+', 0o644) or {
 		eprintln('failed to create file $file_name')
        return
        }
        f.write_bytes(s.data, s.data.len)
        f.close()     
}

fn run(ml &gst.GMainLoop) {
	ml.run()
}

fn take_func(cmd cli.Command) {
	n := cmd.flags.get_int('number') or { panic('failed to get \'namber\' flag: $err') }
	println(n)
	skip := cmd.flags.get_int('skip') or { panic('failed to get \'times\' flag: $err') }
	device := cmd.flags.get_string('device') or { panic('failed to get \'device\' flag: $err') }
	s := strconv.v_sprintf(gst_line, device, camera_name)
	println(s)
	
	
	p := gst.parse_launch(s) or {
		println(err)
		return
	}
	defer {
		p.unref()
	}
	
	e := p.get_by_name(camera_name) or {
		println(err)
		return
	}
	ml := gst.new_main_loop()
	go run(ml)
	p.set_state(gst.StatePlaying)
	take_pictures(n, skip, e)
	ml.quit()
	println('End of record')
}

fn main() {

	mut cmd := cli.Command{
		name: 'take',
		description: 'Takes a number of pictures',
		version: '1.0.0',
		parent: 0
		execute: take_func
	}                
	
	cmd.add_flag(cli.Flag{
		flag: .int,
		name: 'number',
		abbrev: "n", 
		value: '3',
		description: 'Number of times the the picture to be taken'
	})    

	cmd.add_flag(cli.Flag{
		flag: .string,
		name: 'device',
		abbrev: "d", 
		value: '/dev/video0',
		description: 'Video capture device'
	})    

	cmd.add_flag(cli.Flag{
		flag: .int,
		name: 'skip',
		abbrev: "s", 
		value: '10',
		description: 'Frames to skip between pictures'
	})    
	
	cmd.parse(os.args) 
}
