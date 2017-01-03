module VGA_Practice (rst, clk, vga_red, vga_green, vga_blue, hsync, vsync, type);
	input rst, clk;
	output [3:0]vga_red;
	output [3:0]vga_green;
	output [3:0]vga_blue;
	output hsync;
	output vsync;

	input [1:0]type;

	VGA disp(rst, clk, vga_red, vga_green, vga_blue, hsync, vsync, type);
	
endmodule

module VGA(rst, clk, vga_red, vga_green, vga_blue, hsync, vsync, type);
	input clk;
	input rst;
	input [1:0]type;
	
	output reg [3:0]vga_red;
	output reg [3:0]vga_green;
	output reg [3:0]vga_blue;
	output hsync, vsync;

	wire [10:0]horizon;
	wire [10:0]verticle;
		
	always @(posedge clk) begin
		if(valid) begin
			case (type)
				2'b00: begin //black
					vga_red = 0;
					vga_green = 0;
					vga_blue = 0;
				end
				2'b01: begin //red
					if	(((horizon <= 200 || horizon >= 600) && (verticle <= 150 || verticle >= 450))  ||  ((horizon >= 200 && horizon <= 600 && verticle >= 150 && verticle <= 450))) begin
						vga_red = 15;
					end
					else begin 
						vga_red = 0;
					end
					vga_green = 0;
					vga_blue = 0;
				end
				2'b10: begin //green
					if	(((horizon <= 200 || horizon >= 600) && (verticle <= 150 || verticle >= 450))  ||  ((horizon >= 200 && horizon <= 600 && verticle >= 150 && verticle <= 450))) begin
						vga_green = 0;
					end
					else begin 
						vga_green = 15;
					end
					vga_red = 0;
					vga_blue = 0;
				end
				2'b11: begin //blue
					if(!((horizon >= 200 && horizon <= 600 && verticle >= 150 && verticle <= 450))) begin
						vga_blue = 15;
					end
					else begin 
						vga_blue = 0;
					end
					vga_green = 0;
					vga_red = 0;
				end
			endcase
		end
		else begin
			vga_red = 0;
			vga_green = 0;
			vga_blue = 0;
		end
	end
	
	synchrogazer VGA(clk, rst, hsync, vsync, valid, horizon, verticle);
	
endmodule

module synchrogazer(clk, rst, hsync, vsync, valid, horizon, verticle);

	input clk;
	input rst;

	output reg hsync;
	output reg vsync;
	output reg valid;
	output reg [10:0]horizon;
	output reg [10:0]verticle;

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

module picture ();
	
endmodule
