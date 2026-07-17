module Design_Game_VGA(
input clk, // su dung tan so 50mhz
input resetn,
// tin hieu vga 
output h_sync, 
output v_sync, 
output blank_n,
output sync_n,
output [7:0]vga_r, 
output [7:0]vga_g, 
output [7:0]vga_b,
// button di chuyen nhan vat
input [3:0] btn_move_figure,
// input test theo chuc nang 
input [1:0]sw
); 

// cac trang thai setup ban dau 
localparam FIGURE_WIDTH = 32; 
localparam FIGURE_HIGHT = 32;
localparam START_X_FIGURE = 150; 
localparam START_Y_FIGURE = 700;

wire clk_82_5mhz;
// pll tao tan so 82.5Mhz
PLL_82_5Mhz clock_1(
	.inclk0(clk),
	.c0(clk_82_5mhz)
	);

// module dieu khien VGA 
wire [11:0] counter_x; 
wire [11:0] counter_y;
wire frame_on;
wire frame_complete; 

vga_controller vga_1(
	.clk(clk_82_5mhz), 
	.resetn(resetn), 
	.hsync(h_sync), 
	.vsync(v_sync), 
	.blank_n(blank_n),
	.sync_n(sync_n),
	.counter_x(counter_x), 
	.counter_y(counter_y), 
	.video_on(frame_on),
	.frame_finish(frame_complete)
);

// thuc hien lay du lieu anh tu rom
wire [11:0] addr_rom; 
wire [23:0] data_rom;

rom_image rom_1(
	.clock(~clk_82_5mhz), 
	.address(addr_rom),  
	.q(data_rom)
); 


// thu hien qua trinh xu ly vi tri nhan vat tren khung hinh 
wire [11:0] index_pixel_x; 
wire [11:0] index_pixel_y;
reg [11:0] latch_pos_x = START_X_FIGURE; 
reg [11:0] latch_pos_y = START_Y_FIGURE;
wire moving_figure;

image_controller #(
	.screen_max_x(1366),
	.screen_max_y(768),
	.start_x(START_X_FIGURE),
	.start_y(START_Y_FIGURE),
	.jump_x(5), 
	.jump_y(5),
	.figure_w(FIGURE_WIDTH),
	.figure_h(FIGURE_HIGHT)
) figure_obj_1 (
	.clk(clk),  // -> su dung tan so 50mhz
	.resetn(resetn),
	.btn_left(btn_move_figure[0]),
	.btn_right(btn_move_figure[1]),
	.btn_top(btn_move_figure[2]),
	.btn_bot(btn_move_figure[3]),
	.pos_x(index_pixel_x),
	.pos_y(index_pixel_y),
	.is_moving(moving_figure)
);

always @(posedge frame_complete or negedge resetn) begin 
	if(!resetn) begin 
		latch_pos_x <= START_X_FIGURE; 
		latch_pos_y <= START_Y_FIGURE;
	end else begin 
		latch_pos_x <= index_pixel_x; 
		latch_pos_y <= index_pixel_y; 
	end 
end 

// thuc hien qua trinh xac dinh vung cho phep ve nhan vat tren khung hinh lon 
wire in_sprite_zone; 
assign in_sprite_zone = (counter_x >= latch_pos_x) && (counter_x < latch_pos_x + FIGURE_WIDTH) && 
								(counter_y >= latch_pos_y) && (counter_y < latch_pos_y + FIGURE_HIGHT);
// bo dem thuc hien lam cham chuyen doi hinh anh nhan vat 

reg[5:0] source_frame =0;
always @(posedge frame_complete or negedge resetn) begin 
	if(!resetn) begin source_frame <= 0; end 
	else begin 
		if(!moving_figure) begin source_frame <= 0; 
		end else begin 
			if(source_frame[5:3] == 3'd3) begin source_frame <= 6'd0; end 
			else begin source_frame <= source_frame + 1'b1; end 
		end
	end 
end
					
// thuc hien qua trinh tinh dia chi rom de lay du lieu pixel anh 
wire [2:0] offset_image_rom; 
assign offset_image_rom = (source_frame[5:3] ==1) ? 1 :
								  (source_frame[5:3] ==2) ? 2 :
								  (source_frame[5:3] ==3) ? 3 : 0;
wire [9:0] dx; 
wire [9:0] dy;
assign dx = counter_x - latch_pos_x; 
assign dy = (counter_y - latch_pos_y) << 5;	

assign addr_rom = (offset_image_rom << 10) + dx + dy; 				  								  
								  
// module game controller -> phan thuc hien phat trien
reg [7:0]vga_r_reg =0; 
reg [7:0]vga_g_reg =0;
reg [7:0]vga_b_reg =0;

// thuc hien qua trinh 


always @(negedge clk_82_5mhz or negedge resetn) begin 
	if(!resetn) begin 
		vga_r_reg <= 0; 
		vga_g_reg <= 0; 
		vga_b_reg <= 0;
	end 
	else begin 
		if(frame_on) begin 
			case (sw)
				2'b00:
					begin // pink
						vga_r_reg <= 8'd255; 
						vga_g_reg <= 8'd0; 
						vga_b_reg <= 8'd255;
						/*if(in_sprite_zone) begin 
							vga_r_reg <= data_rom[23:16]; 
							vga_g_reg <= data_rom[15:8]; 
							vga_b_reg <= data_rom[7:0]; 
						end*/
					end 
				2'b01:
					begin // aqua
						vga_r_reg <= 8'd0; 
						vga_g_reg <= 8'd255; 
						vga_b_reg <= 8'd239;
					end 
				2'b10:
					begin // mediumSpringGreen
						vga_r_reg <= 0; 
						vga_g_reg <= 250; 
						vga_b_reg <= 154;
					end 
				2'b11:
					begin // orangeRed 
						vga_r_reg <= 255; 
						vga_g_reg <= 69; 
						vga_b_reg <= 0;
					end 
				default: 
					begin
						vga_r_reg <= 0; 
						vga_g_reg <= 0; 
						vga_b_reg <= 0;
					end
			endcase
		end 
	end 
end 

// gan du lieu ra ben ngoai 
assign vga_r = vga_r_reg;
assign vga_g = vga_g_reg;
assign vga_b = vga_b_reg;


endmodule 