// Video sync generator, used to drive a VGA monitor.
// Timing from: http://www.tinyvga.com/vga-timing
// To use:
//  - Wire the hsync and vsync signals to top level outputs
//  - Add a 3-bit (or more) "rgb" output to the top level

module hvsync_generator(clk, mode, hsync, vsync, display_on, hpos, vpos);
    parameter integer NM = 4; // number of modes
    // [0]  VGA    640 x  480 @ 60 fps ( 25.175 MHz)
    // [1] SVGA    800 x  600 @ 60 fps ( 40.0   MHz)
    // [3]  qHD    960 x  540 @ 60 fps ( 34.694 MHz)
    // [3]   HD   1280 x  720 @ 60 fps ( 64.0   MHz)
    //--------[ Bit width ] ----- Mode------      [3]      [2]      [1]      [0]
    parameter [11*NM-1:0] H_ACTIVE_PIXELS = {11'd1280, 11'd960, 11'd800, 11'd640}; // horizontal display width
    parameter [10*NM-1:0] H_FRONT_PORCH   = {10'd  48, 10'd  8, 10'd 40, 10'd 16}; // horizontal right border
    parameter [10*NM-1:0] H_SYNC_WIDTH    = {10'd  32, 10'd 32, 10'd128, 10'd 96}; // horizontal sync width
    parameter [10*NM-1:0] H_BACK_PORCH    = {10'd  80, 10'd 40, 10'd 88, 10'd 48}; // horizontal left border
    parameter [   NM-1:0] H_SYNC          = { 1'b   1,  1'b  1,  1'b  1,  1'b  0}; // 0 (-), 1 (+)
    parameter [10*NM-1:0] V_ACTIVE_LINES  = {10'd 720, 10'd540, 10'd600, 10'd480}; // vertical display height
    parameter [ 9*NM-1:0] V_FRONT_PORCH   = { 9'd   7,  9'd  2,  9'd  1,  9'd 10}; // vertical bottom border
    parameter [ 9*NM-1:0] V_SYNC_HEIGHT   = { 9'd   8,  9'd  8,  9'd  4,  9'd  2}; // vertical sync # lines
    parameter [ 9*NM-1:0] V_BACK_PORCH    = { 9'd   6,  9'd  3,  9'd 23,  9'd 33}; // vertical top border
    parameter [   NM-1:0] V_SYNC          = { 1'b   0,  1'b  0,  1'b  1,  1'b  0}; // 0 (-), 1 (+)

	input wire clk;
	input wire [1:0] mode;
	output reg hsync, vsync;
	output wire display_on;

	// derived constants
	wire [10:0] h_sync_start = H_ACTIVE_PIXELS[11*mode+:11] + H_FRONT_PORCH[10*mode+:10];
	wire [10:0] h_sync_end   = h_sync_start + H_SYNC_WIDTH[10*mode+:10] - 11'd1;
	wire [10:0] h_max        = h_sync_end + H_BACK_PORCH[10*mode+:10];
	wire [ 9:0] v_sync_start = V_ACTIVE_LINES[10*mode+:10] + V_FRONT_PORCH[9*mode+:9];
	wire [ 9:0] v_sync_end   = v_sync_start + V_SYNC_HEIGHT[9*mode+:9] - 10'd1;
	wire [ 9:0] v_max        = v_sync_end + V_BACK_PORCH[9*mode+:9];

	output reg [10:0] hpos; // horizontal position counter
	output reg [ 9:0] vpos; // vertical position counter

	wire hmaxxed = (hpos >= h_max); // set when hpos exceeds maximum
	wire vmaxxed = (vpos >= v_max); // set when vpos exceeds maximum
	wire hactive = (hpos >= h_sync_start) && (hpos <= h_sync_end);
	wire vactive = (vpos >= v_sync_start) && (vpos <= v_sync_end);

	always @(posedge clk)
	begin
		hsync <= hactive ^ ~H_SYNC[mode];
		hpos <= hmaxxed ? 0 : hpos + 1;
		vsync <= vactive ^ ~V_SYNC[mode];
		vpos <= hmaxxed ? (vmaxxed ? 0 : vpos + 1) : vpos;
	end

	// display_on is set when beam is in "safe" visible frame
	assign display_on = (hpos < H_ACTIVE_PIXELS[11*mode+:11]) && (vpos < V_ACTIVE_LINES[10*mode+:10]);

endmodule
