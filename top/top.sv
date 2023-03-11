module top (
    input sys_clk,
    input sys_resetn,

////  video clocks
//    input clk_pixel,
//    input clk_5x_pixel,
//    input locked,

    //output logic [2:0] tmds,
    //output logic tmds_clock

    output [2:0] led2,  

    // output signals
    output       tmds_clk_n,
	output       tmds_clk_p,
	output [2:0] tmds_d_n,
	output [2:0] tmds_d_p

);
//logic [2:0] tmds;
//logic tmds_clock;

// HDMI domain clocks
logic[2:0] tmds;
wire clk_pixel;  // 720p pixel clock: 74.25 Mhz
wire clk_pixel_x5;  // 5x pixel clock: 371.25 Mhz
wire pll_lock;

logic clk_audio;
//logic reset;

Gowin_rPLL u_pll(
        .clkout(clk_pixel_x5), //output clkout
        .lock(pll_lock), //output lock
        .clkin(sys_clk) //input clkin
 );
Gowin_CLKDIV u_div_5(
        .clkout(clk_pixel), //output clkout
        .hclkin(clk_pixel_x5), //input hclkin
        .resetn(sys_resetn & pll_lock) //input resetn
);

reg [32:0] cnt_clk;              
reg [32:0] cnt_pixel;  
reg [32:0] cnt_pixel5;              

assign led2[0] = (cnt_clk < 26'd500) ? 2'b1 : 2'b0;
assign led2[2] = (cnt_pixel < 26'd500) ? 2'b1 : 2'b0;
assign led2[1] = (cnt_pixel5 < 26'd2500_000) ? 2'b1 : 2'b0;


always @ (posedge sys_clk or negedge sys_resetn) begin
    if(!sys_resetn)                  
        cnt_clk <=26'd0;
    else if(cnt_clk < 26'd1000)
        cnt_clk <= cnt_clk + 1'b1;    
    else
        cnt_clk <= 26'd0;     
end

always @ (posedge clk_pixel or negedge sys_resetn) begin
    if(!sys_resetn)                  
        cnt_pixel <=26'd0;
    else if(cnt_pixel < 26'd1000)
        cnt_pixel <= cnt_pixel + 1'b1;      
    else
        cnt_pixel <= 26'd0;           
end

always @ (posedge clk_pixel_x5 or negedge sys_resetn) begin
    if(!sys_resetn)                  
        cnt_pixel5 <=26'd0;
    else if(cnt_pixel5 < 26'd5000_000)
        cnt_pixel5 <= cnt_pixel5 + 1'b1;      
    else
        cnt_pixel5 <= 26'd0;
end

logic [15:0] audio_sample_word [1:0] = '{16'd0, 16'd0};
always @(posedge clk_audio)
  audio_sample_word <= '{audio_sample_word[1] + 16'd1, audio_sample_word[0] - 16'd1};

logic [23:0] rgb = 24'h00ff00;
//24'hffffff;   // R G B

logic [9:0] cx, cy, screen_start_x, screen_start_y, frame_width, frame_height, screen_width, screen_height;
// Border test (left = red, top = green, right = blue, bottom = blue, fill = black)
always @(posedge clk_pixel)
  rgb <= {cx == 0 ? ~8'd0 : 8'd0, cy == 0 ? ~8'd0 : 8'd0, cx == screen_width - 1'd1 || cy == screen_width - 1'd1 ? ~8'd0 : 8'd0};

// 640x480 @ 59.94Hz
hdmi #(.VIDEO_ID_CODE(4), .VIDEO_REFRESH_RATE(59.94), .AUDIO_RATE(48000), .AUDIO_BIT_WIDTH(16)) hdmi(
  .clk_pixel_x5(clk_pixel_x5),
  .clk_pixel(clk_pixel),
  .clk_audio(clk_audio),
  .reset(~sys_resetn),
  .rgb(rgb),
  .audio_sample_word(audio_sample_word),
  .tmds(tmds),
  .tmds_clock(tmds_clock),
  .cx(cx),
  .cy(cy),
  .frame_width(frame_width),
  .frame_height(frame_height),
   .screen_width(screen_width),
   .screen_height(screen_height)
);


    // Gowin LVDS output buffer
    ELVDS_OBUF tmds_bufds [3:0] (
        .I({clk_pixel, tmds}),
        .O({tmds_clk_p, tmds_d_p}),
        .OB({tmds_clk_n, tmds_d_n})
    );

endmodule
