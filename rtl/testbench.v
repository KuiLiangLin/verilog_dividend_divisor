`timescale 1ns/1ps
module test_bench ();

//**************************** wire & reg**********************//
initial $display("//***************************************");
initial $display("//==top input : clk,  enable, divident, divisor, rstn");
initial $display("//==top output :  result");
initial $display("//***************************************");
reg	[31:0] dividend;
reg	[31:0] divisor;
reg	clk;
reg	rstn;
reg	enable;
wire [31:0]result;

//**************************** module **********************//
initial $display("===module : divdiv");
divdiv divdiv(.clk(clk),
		.rstn(rstn),
		.enable(enable),
		.dividend(dividend),
		.divisor(divisor),
		.result(result)
);

//**************************** clock gen **********************//
`define CYCLE 5
initial
begin
	$display("===starting generating clk");
	force clk = 1'b0;
	forever #(`CYCLE/2) force clk = ~clk;
end

//**************************** initial and wavegen **********************//
initial 
begin
	$display("===starting dump waveform");
	$dumpfile("out.vcd");
	$dumpvars(0,divdiv);
end

//**************************** main **********************//
reg [31:0]index_2;
initial
begin

	force clk = 1'b0;
	force rstn = 1'b0;
	force enable = 1'b0;
	force dividend = 32'b0;
	force divisor = 32'b0;


	$display("===reset");
	reset;

	#1_000;
	$display("===starting testing");
	for(index_2 = 32'd1; index_2 < 32'd60; index_2 = index_2 + 32'd3)
	begin 
		$display("send : %d, %d" , index_2, index_2*index_2 + 32'd1);
		send_data(index_2, index_2*index_2 + 32'd7); 
		@(negedge clk);
		force enable = 1;
		repeat(100) @(posedge clk);
		force enable = 0;	
	end


	$display("===all done");
	#100000 $finish;
end

//*******************************task reset******************//
task reset;
begin
	force rstn = 1'b1;
	#1_000;
	force rstn = 1'b0;
	#1_000;
	force rstn = 1'b1;
	#1_000;
end
endtask

//****************************task send_data*****************//
task send_data;
input [31:0] input_1;
input [31:0] input_2;
begin
	force dividend = input_2;
	force divisor = input_1;
end
endtask





endmodule
