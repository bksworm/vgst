module gst

#flag -pthread -I/home/k9/.local/include/gstreamer-1.0 -I/usr/include/glib-2.0 -I/usr/lib/x86_64-linux-gnu/glib-2.0/include
#flag -L/home/k9/.local/lib/x86_64-linux-gnu -lgstapp-1.0 -lgstreamer-1.0 -lgobject-2.0 -lglib-2.0
#flag -I @VROOT/gst
#include <gst/gst.h>
#include "c/gst.h"
#flag @VROOT/gst/c/gst.o
pub struct C.GstObject 
pub struct C.GError 
pub struct C.GstElement

pub struct C.GstBus
pub struct C.GstBuffer
pub struct C.GstMapInfo
pub struct C.GMainLoop
pub struct C.GstAppSink
pub struct C.GstSample

const (
	StateVoidPending = C.GST_STATE_VOID_PENDING
	StateNull        = C.GST_STATE_NULL
	StateReady       = C.GST_STATE_READY
	StatePaused      = C.GST_STATE_PAUSED
	StatePlaying     = C.GST_STATE_PLAYING
)

fn C.x_gst_shim_init()

// GObject
fn C.g_free(arg_1 voidptr)

// GstObject
fn C.gst_object_get_name(arg_1 &C.GstObject) charptr

fn C.gst_object_unref(arg_1 &C.GstObject)

// GError
fn C.getErrorMsg(arg_1 &C.GError) charptr

fn C.g_clear_error(arg_1 &C.GError)

// GstBuffer
fn C.x_gst_buffer_map(arg_1 &C.GstBuffer, arg_2 &C.GstMapInfo) int

fn C.gst_buffer_unmap(arg_1 &C.GstBuffer, arg_2 &C.GstMapInfo)

fn C.x_gst_buffer_get_duration(arg_1 &C.GstBuffer) u64

fn C.x_gst_map_info_data(arg_1 &C.GstMapInfo) byteptr

fn C.x_gst_map_info_size(arg_1 &C.GstMapInfo) int

// GstSample
fn C.gst_sample_get_buffer(arg_1 &C.GstSample) &C.GstBuffer

fn C.gst_sample_unref(arg_1 &C.GstSample)

// GstElement
fn C.gst_element_set_state(arg_1 &C.GstElement, arg_2 int)

// GstAppsink
fn C.gst_app_sink_pull_sample(arg_1 &C.GstAppSink) &C.GstSample

fn C.gst_app_sink_is_eos(arg_1 &C.GstAppSink) int

// GstAppsrc
fn C.x_gst_app_src_push_buffer(arg_1 &C.GstElement, arg_2 byteptr, arg_3 int) int

// GStPipeline
fn C.gst_parse_launch(arg_1 charptr, arg_2 &C.GError) &C.GstElement

fn C.x_gst_pipeline_get_bus(arg_1 &C.GstElement) &C.GstBus

// GstBin
fn C.x_gst_bin_get_by_name(arg_1 &C.GstElement, arg_2 charptr) &C.GstElement

// GStLoop
fn C.g_main_loop_new(arg_1 voidptr, arg_2 bool) &C.GMainLoop

fn C.g_main_loop_run(arg_1 &C.GMainLoop)

fn C.g_main_loop_quit(arg_1 &C.GMainLoop)

fn C.g_main_loop_is_running(arg_1 &C.GMainLoop) int
