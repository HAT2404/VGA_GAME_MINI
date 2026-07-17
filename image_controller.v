module image_controller #(
// gioi han bien man hinh 
parameter screen_max_x = 1366, 
parameter screen_max_y = 768,
// vi tri ban dau cua doi tuong 
parameter start_x = 150,  // Horizontal = 1366
parameter start_y = 700,   // Vertical = 768 
// so buoc nhay pixel moi khi nhan btn
parameter jump_x = 5, 
parameter jump_y = 5,
// kich thuoc anh nhan vat 
parameter figure_w = 32, 
parameter figure_h = 32
)
(
input clk, // su dung tan so 50mhz 
input resetn, 
// button dieu khien trai, phai, tren, duoi
input btn_right, 
input btn_left, 
input btn_top, 
input btn_bot, 
// vi tri xac dinh du lieu
output [11:0]pos_x, 
output [11:0]pos_y, 
output is_moving

);

// thuc hien buffer de giam nhieu button 
reg bnt_left_1 =0;
reg bnt_left_2 =0; 
reg bnt_right_1 =0;
reg bnt_right_2 =0; 
reg bnt_top_1 =0;
reg bnt_top_2 =0; 
reg bnt_bottom_1 =0; 
reg bnt_bottom_2 =0; 
wire left_press, right_press, top_press, bottom_press; 

always @(posedge clk or negedge resetn) begin
	if(!resetn) begin 
		bnt_left_1 <=0; 
		bnt_left_2 <=0;  
		bnt_right_1 <=0; 
		bnt_right_2 <=0; 
		bnt_top_1 <=0;
		bnt_top_2 <=0;  
		bnt_bottom_1 <=0; 
		bnt_bottom_2 <=0; 
	end else begin 
		// button left
		bnt_left_1 <= btn_left; 
		bnt_left_2 <= bnt_left_1;
		// button right 
		bnt_right_1 <= btn_right; 
		bnt_right_2 <= bnt_right_1;
		// button top 
		bnt_top_1 <= btn_top; 
		bnt_top_2 <= bnt_top_1; 
		// button bottom 
		bnt_bottom_1 <= btn_bot; 
		bnt_bottom_2 <= bnt_bottom_1; 
	end 
end

// thuc hien canh len cua cac tin hieu button sau khi buffer 
assign left_press = bnt_left_1 & ~bnt_left_2; 
assign right_press = bnt_right_1 & ~bnt_right_2;
assign top_press = bnt_top_1 & ~bnt_top_2;
assign bottom_press = bnt_bottom_1 & ~bnt_bottom_2;

// cap nhat toa do theo truc x khi nhan button 
reg [11:0] pos_x_reg = start_x;
reg enable_moving_x =0; 
always @(posedge clk or negedge resetn) begin 
	if(!resetn) begin
		pos_x_reg = start_x; 
		enable_moving_x <=0; 
	end else begin 
		case ({left_press, right_press})
			2'b01:  // -> di chuyen nhan vat ve ben phai
				begin 
					enable_moving_x <=1; 
					if((pos_x_reg + figure_w + jump_x) < screen_max_x) begin pos_x_reg <= pos_x_reg + jump_x; end 
					else begin pos_x_reg <= screen_max_x - figure_w;  end 
					
				end 
			2'b10:  // -> di chuyen nhan vat ve ben trai
				begin 
					enable_moving_x <=1; 
					if(pos_x_reg > jump_x) begin pos_x_reg <= pos_x_reg - jump_x; end 
					else begin 
						pos_x_reg <=0;
					end 
				end 
			default: 
				begin 
					enable_moving_x <=0; 
					pos_x_reg <= pos_x_reg;
				end 
		endcase 
	end 
end 

// cap nhat toa do theo truc y khi nhan button 

reg [11:0] pos_y_reg = start_y; 
reg enable_moving_y =0; 
always @(posedge clk or negedge resetn) begin 
	if(!resetn) begin 
		pos_y_reg <= start_y;
		enable_moving_y <=0;
	end else begin 
		case({top_press,bottom_press})
			2'b01: // -> di chuyen nhan vat xuong phia duoi
				begin
					enable_moving_y <=1;
					if((pos_y_reg + figure_h + jump_y) < screen_max_y ) begin pos_y_reg <= pos_y_reg + jump_y; end 
					else begin pos_y_reg <= screen_max_y - figure_h; end 
				end 
			2'b10: // di chuyen nhan vat xuong len phia tren
				begin 
					enable_moving_y <=1;
					if(pos_y_reg > jump_y) begin pos_y_reg <= pos_y_reg - jump_y; end 
					else begin pos_y_reg <= 0; end 
				end 
			default:
				begin
					enable_moving_y <=0;
					pos_y_reg <= pos_y_reg; 
				end 
		endcase 
	end 
end 

// thuc hien gan vi tri ra ben ngoai 

assign pos_x = pos_x_reg;
assign pos_y = pos_y_reg;
assign is_moving = enable_moving_x | enable_moving_y;

endmodule 

