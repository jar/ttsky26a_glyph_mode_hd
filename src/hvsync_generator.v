// Video sync generator, used to drive a VGA monitor.
// Timing from: http://www.tinyvga.com/vga-timing
// Wire the hsync and vsync signals to top level outputs

module hvsync_generator(clk, mode, hsync, vsync, display_on, hpos, vpos);
    parameter integer NM = 4; // number of modes
    // [0]  VGA (Historical)  640 x  480 @ 60 fps (25.175 MHz) DMT0659
    // [1] SVGA (  VESA DMT)  800 x  600 @ 60 fps (40.000 MHz) VESA DMT
    // [2]   HD (      720p) 1280 x  720 @ 60 fps (74.250 MHz) CTA-770.3
    // [3]  FHD (   1080p30) 1920 x 1080 @ 30 fps (74.250 MHz) SMPTE 274M
    //--------[ Bit width ] ----- Mode------      [3]       [2]      [1]      [0]
    parameter [12*NM-1:0] H_ACTIVE_PIXELS = {12'd1920, 12'd1280, 12'd800, 12'd640}; // horizontal display width
    parameter [11*NM-1:0] H_FRONT_PORCH   = {11'd  88, 11'd 110, 11'd 40, 11'd 16}; // horizontal right border
    parameter [11*NM-1:0] H_SYNC_WIDTH    = {11'd  44, 11'd  40, 11'd128, 11'd 96}; // horizontal sync width
    parameter [11*NM-1:0] H_BACK_PORCH    = {11'd 148, 11'd 220, 11'd 88, 11'd 48}; // horizontal left border
    parameter [   NM-1:0] H_SYNC          = { 1'b   1,  1'b   1,  1'b  1,  1'b  0}; // 0 (-), 1 (+)
    parameter [11*NM-1:0] V_ACTIVE_LINES  = {11'd1080, 11'd 720, 11'd600, 11'd480}; // vertical display height
    parameter [10*NM-1:0] V_FRONT_PORCH   = {10'd   4, 10'd   5, 10'd  1, 10'd 10}; // vertical bottom border
    parameter [10*NM-1:0] V_SYNC_HEIGHT   = {10'd   5, 10'd   5, 10'd  4, 10'd  2}; // vertical sync # lines
    parameter [10*NM-1:0] V_BACK_PORCH    = {10'd  36, 10'd  20, 10'd 23, 10'd 33}; // vertical top border
    parameter [   NM-1:0] V_SYNC          = { 1'b   1,  1'b   1,  1'b  1,  1'b  0}; // 0 (-), 1 (+)

	input wire clk;
	input wire [1:0] mode;
	output reg hsync, vsync;
	output wire display_on;

	// derived constants
	wire [11:0] h_sync_start = H_ACTIVE_PIXELS[12*mode+:12] + H_FRONT_PORCH[11*mode+:11];
	wire [11:0] h_sync_end   = h_sync_start + H_SYNC_WIDTH[11*mode+:11] - 12'd1;
	wire [11:0] h_max        = h_sync_end + H_BACK_PORCH[11*mode+:11];
	wire [10:0] v_sync_start = V_ACTIVE_LINES[11*mode+:11] + V_FRONT_PORCH[10*mode+:10];
	wire [10:0] v_sync_end   = v_sync_start + V_SYNC_HEIGHT[10*mode+:10] - 11'd1;
	wire [10:0] v_max        = v_sync_end + V_BACK_PORCH[10*mode+:10];

	output reg [11:0] hpos; // horizontal position counter
	output reg [10:0] vpos; // vertical position counter

	wire hactive = (hpos >= h_sync_start) && (hpos <= h_sync_end);
	wire vactive = (vpos >= v_sync_start) && (vpos <= v_sync_end);
	wire hmaxxed = (hpos >= h_max); // set when hpos exceeds maximum
	wire vmaxxed = (vpos >= v_max); // set when vpos exceeds maximum

	always @(posedge clk)
	begin
		hsync <= hactive ^ ~H_SYNC[mode];
		hpos <= hmaxxed ? 0 : hpos + 1;
		vsync <= vactive ^ ~V_SYNC[mode];
		vpos <= hmaxxed ? (vmaxxed ? 0 : vpos + 1) : vpos;
	end

	// display_on is set when beam is in "safe" visible frame
	assign display_on = (hpos < H_ACTIVE_PIXELS[12*mode+:12]) && (vpos < V_ACTIVE_LINES[11*mode+:11]);

endmodule
