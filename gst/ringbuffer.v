module gst

//The ring buffer implementation based on 
// https://embeddedartistry.com/blog/2017/05/17/creating-a-circular-buffer-in-c-and-c/

// The  definition of circular buffer structure
struct CBuf {
mut:
	buffer []byte
	head int
	tail int
	max int //of the buffer
	full bool
}

/// Pass in a storage buffer and size 
/// Returns a circular buffer handle
fn new_circular_buf(buf []byte) CBuf{
	return CBuf{
		buffer: buf
		head:0
		tail:0
		max:buf.len
		full:false
	}
	
}

/// Free a circular buffer structure.
/// Does not free data buffer; owner is responsible for that
//void circular_buf_free(CBuf_handle_t CBuf);

/// Reset the circular buffer to empty, head == tail
fn (mut c CBuf) reset(){
	c.head = 0
    c.tail = 0
    c.full = false
}

/// Put version 1 continues to add data if the buffer is full
/// Old data is overwritten
fn (mut c CBuf) put(data byte) {
    c.buffer[c.head] = data
    c.advance_pointer()
}

/// Put Version 2 rejects new data if the buffer is full
/// Returns true on success, false if buffer is full
fn (mut c CBuf) put2(data byte) bool{
    mut r := false 
    if !c.full {
        c.buffer[c.head] = data
        c.advance_pointer()
        r = true
    }
    return r
}

/// Retrieve a value from the buffer
/// Returns true on success, false if the buffer is empty
fn (mut c CBuf) get(data &byte) bool {  
	mut r := false
    if !c.empty()  {
        data = c.buffer[c.tail]
        c.retreat_pointer()
        r = true
    }
    return r
}

// Returns true if the buffer is empty
fn (c CBuf) empty() bool {
	return (!c.full && (c.head == c.tail))
}

/// Returns true if the buffer is full
fn (c CBuf) full() bool{
	return c.full
}

/// Returns the maximum capacity of the buffer
fn (c CBuf) cap() int{
	return c.max
}

/// Returns the current number of elements in the buffer
fn (c CBuf) size() int{
	mut size := c.max
	if c.full== false {
		if c.head >= c.tail {
			size = c.head - c.tail
		}
		else {
			size = c.max + c.head - c.tail
		}
	}
	return size
}

// helper functions
fn (mut c CBuf) advance_pointer(){
	if c.full {
		c.tail = (c.tail + 1) % c.max
	}
	c.head = (c.head + 1) % c.max
	c.full = c.head == c.tail
}

fn (mut c CBuf)retreat_pointer(){
	c.full = false
	c.tail = (c.tail + 1) % c.max
}