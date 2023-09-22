module ClockDivider(
    input clk, rst_n,
    output clk_1kHz, clk_1Hz
);

    localparam input_fr = 450000000;
  	localparam output_fr = 1;
  	localparam MAX       = input_fr/output_fr;
  	localparam width_clk     = 28+1;

	localparam input_fr2 = 450000000;
  	localparam output_fr2 = 1000;
  	localparam MAX2       = input_fr/output_fr;
  	localparam width_clk2     = 18+1;

    SingleClockDivider#(.width(width_clk2),.MAX(MAX2)) Clock_1kHz(.clk(clk), .rst_n(rst_n), .en(1'b1), .div_clk(clk_1kHz));
    SingleClockDivider#(.width(width_clk),.MAX(MAX)) Clock_1HzClock(.clk(clk), .rst_n(rst_n), .en(1'b1), .div_clk(clk_1Hz));
	SingleClockDivider#(.width(width_clk3),.MAX(MAX)) Clock_100HzClock(.clk(clk), .rst_n(rst_n), .en(1'b1), .div_clk(clk_1Hz));

endmodule