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
pub struct C.GMainLoop
pub struct C.GstAppSink
pub struct C.GstSample
pub struct C.GstMemory


const (
	StateVoidPending = C.GST_STATE_VOID_PENDING
	StateNull         = C.GST_STATE_NULL
	StateReady        = C.GST_STATE_READY
	StatePaused       = C.GST_STATE_PAUSED 
	StatePlaying      = C.GST_STATE_PLAYING
)

fn C.x_gst_shim_init()
//GObject
fn C.g_free(voidptr)

//GstObject
fn C.gst_object_get_name(&C.GstObject) charptr
fn C.gst_object_unref(&C.GstObject)

//GError
fn C.getErrorMsg(&C.GError) charptr
fn C.g_clear_error(&C.GError)

//GstBuffer
fn C.x_gst_buffer_map(&C.GstBuffer, &C.GstMapInfo) int
fn C.gst_buffer_unmap(&C.GstBuffer, &C.GstMapInfo)
fn C.x_gst_buffer_get_duration(&C.GstBuffer) u64
fn C.x_gst_map_info_data(&C.GstMapInfo) byteptr
fn C.x_gst_map_info_size(&C.GstMapInfo) int

//GstSample
fn C.gst_sample_get_buffer(&C.GstSample) &C.GstBuffer
fn C.gst_sample_unref(&C.GstSample)

//GstElement
fn C.gst_element_set_state(&C.GstElement, int)

//GstAppsink
fn C.gst_app_sink_pull_sample(&C.GstAppSink) &C.GstSample
fn C.gst_app_sink_is_eos(&C.GstAppSink) int

//GstAppsrc
fn C.x_gst_app_src_push_buffer(&C.GstElement, byteptr, int) int

//GStPipeline
fn C.gst_parse_launch(charptr, &C.GError) &C.GstElement
fn C.x_gst_pipeline_get_bus(&C.GstElement) &C.GstBus

//GstBin
fn C.x_gst_bin_get_by_name(&C.GstElement, charptr) &C.GstElement

//GStLoop
fn C.g_main_loop_new(voidptr, bool) &C.GMainLoop
fn C.g_main_loop_run(&C.GMainLoop)
fn C.g_main_loop_quit(&C.GMainLoop)
fn C.g_main_loop_is_running(&C.GMainLoop) int