module VGA_Practice(rst, clk, vga_red, vga_green, vga_blue, hsync, vsync, valid, select);
	input clk;
	input rst;
	input [2:0]select;
	
	output reg [3:0]vga_red;
	output reg [3:0]vga_green;
	output reg [3:0]vga_blue;
	output hsync, vsync, valid;
	
	
	always @(posedge clk) begin
		if(valid) begin
			if(select[2]) vga_red = 4'b1111;
			else vga_red = 0;
			if(select[1]) vga_green = 4'b1111;
			else vga_green = 0;
			if(select[0]) vga_blue = 4'b1111;
			else vga_blue = 0;
		end
		else begin
			vga_red = 0;
			vga_green = 0;
			vga_blue = 0;
		end
	end
	
	synchrogazer VGA(clk, rst, hsync, vsync, valid);
	
endmodule

module synchrogazer(clk, rst, hsync, vsync, valid);

	input clk;
	input rst;

	output reg hsync;
	output reg vsync;
	output reg valid;

	reg [10:0]horizon;
	reg [10:0]verticle;

	always @(posedge clk) begin
		if(!rst) begin
			horizon = 0;
			verticle = 0;
		end
		else begin
			if (horizon == 1039) begin
				horizon = 0;
				if (verticle == 665) begin
					verticle = 0;
				end
				else begin
					verticle = verticle + 1;
				end
			end
			else begin
				horizon = horizon + 1;
			end
		end
	end

	always @(posedge clk) begin
		if (!rst) begin
			hsync = 1;
			vsync = 1;
		end
		else begin
			if (horizon == 856) begin
				hsync = 0;
			end
			else if (horizon == 976) begin
				hsync = 1;
			end

			if (verticle == 637) begin
				vsync = 0;
			end
			else if (verticle == 643) begin
				vsync = 1;
			end
		end
	end

	always @(posedge clk) begin
	if (!rst) 
		valid <= 0; 
	else 
		valid <= (horizon < 800 && verticle < 600);  
	end
endmodule
