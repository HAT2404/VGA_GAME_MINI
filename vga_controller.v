module vga_controller(
input clk, // su dung tan so 82.5Mhz
input resetn, 
// tin hieu dieu khien frame cho data
output hsync, 
output vsync, 
// tin hieu dieu khien nen 
output blank_n,    //-> 1: BT | 0: xoa nen 
// tin hieu dong bo green 
output sync_n,     //-> 1: off | 0: on
// tin hieu xac dinh vi tri mau
output [11:0] counter_x, 
output [11:0] counter_y, 
// tin hieu enable write pixel
output video_on, 
output frame_finish
);

assign blank_n =1; 
assign sync_n =1;
// cac thong so cua cua man hinh 
//-> h_banking
localparam HD = 1366; // horizontal display area
localparam HF = 48; // h front left border
localparam HB = 112;// h back right border
localparam HR = 216; // h retrace
localparam H_TOTAL  = 1742; 
// -> v_banking 
localparam VD = 768;// vertical display area
localparam VF = 3;// v front top  border
localparam VB = 6;// v back bottom  border
localparam VR = 13;// v retrace
localparam V_TOTAL  = 790; 

reg [11:0] counter_x_reg =0; 
reg [11:0] counter_y_reg =0; 

always @(posedge clk or negedge resetn) begin 
	if(!resetn) begin 
		counter_x_reg <=0; 
		counter_y_reg <=0;
	end else begin 
		if(counter_x_reg >= H_TOTAL-1) begin 
			if(counter_y_reg >= V_TOTAL-1) begin counter_y_reg <=0; end
			else begin counter_y_reg <= counter_y_reg +1; end 
		end else begin 
			counter_x_reg <= counter_x_reg + 1; 
		end 
	end 
end 


assign counter_x = counter_x_reg; 
assign counter_y = counter_y_reg;

// xu ly tin hieu dieu khien frame vga

reg hsync_reg =1; 
reg vsync_reg =1;

always @(posedge clk or negedge resetn) begin 
	if(!resetn) begin 
		hsync_reg <=1;
		vsync_reg <=1;
	end else begin 
		hsync_reg <= ((counter_x_reg >=HD+HB) && (counter_x_reg <=(HD+HB+HR-1))) ? 0 : 1;
		vsync_reg <= ((counter_y_reg >=VD+VB) && (counter_y_reg <=(VD+VB+VR-1))) ? 0 : 1;
	end 
end 

assign hsync = hsync_reg; 
assign vsync = vsync_reg;

// xu ly tin hieu xac dinh thoi diem xuat ghi du lieu theo tung hang 
assign video_on=(counter_x_reg<(HD)) &&	(counter_y_reg<(VD)); 
// tin hieu thong bao hoan tat qua trinh truyen 1 khung hinh 
assign frame_finish = (counter_x_reg == HD && counter_y_reg == VD) ? 1: 0; 

endmodule 

