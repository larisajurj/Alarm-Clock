`timescale 1ms/1ms
/*
	This module connects the four cascaded counters.
	We also have a custom reset that happens when the time reaches 23:59. It also resets when any 
*/
module CountTime(
    input clk, rst_n, load, en,
    input [3:0] u_min_in, [2:0] z_min_in, [3:0] u_hour_in , [1:0] z_hour_in, 
    output [3:0] u_min_out, [2:0] z_min_out, [3:0] u_hour_out , [1:0] z_hour_out
);
    wire [3:0] MinuteResultedUnit;
    wire [2:0] MinuteResultedTens;
    wire [3:0] HourResultedUnit;
    wire [1:0] HourResultedTens;
    assign u_min_out = MinuteResultedUnit;
    assign z_min_out = MinuteResultedTens;
    assign u_hour_out = HourResultedUnit;
    assign z_hour_out = HourResultedTens;

    wire carryOutMinuteUnit, carryOutMinuteTens, carryOutHourUnit;
	wire resetF;
	reg resetF_ff, resetF_nxt;
	reg reached_final;
	reg interval_errors;
	assign resetF = resetF_ff;
	always @ (*) begin
		resetF_nxt = resetF_ff;
		//it doesn't get here for each change of units, so it doesn't reset early enough
		$display("in this block at", $time);
		reached_final = ((HourResultedTens == 2'b10) & (HourResultedUnit == 4'b0011) & (MinuteResultedTens == 3'b101) & (MinuteResultedUnit ==4'b1001));
		interval_errors = ((HourResultedTens > 2'b10) || (MinuteResultedTens > 3'b101) || (MinuteResultedUnit > 4'b1001) || (HourResultedTens > 4'b1001))
						   || ((HourResultedUnit > 4'b0011) & ((HourResultedTens == 2'b10) & (MinuteResultedTens == 3'b101) & (MinuteResultedUnit ==4'b1001)));
		resetF_nxt = rst_n & ~reached_final & ~interval_errors;
	end

	always @ (posedge clk or negedge rst_n) begin
		if(~rst_n) begin
      		resetF_ff <= 'b0;
    	end else begin
			resetF_ff <= resetF_nxt;
   		end
	end

	Counter#(.WIDTH(4),.MAX(9)) Counter_Minute_UNIT(.en(en),.clk(clk),.rst_n(resetF),.load(load),.loadedUnit(u_min_in), .resultedUnit(MinuteResultedUnit), .carryOut(carryOutMinuteUnit));
	Counter#(.WIDTH(3),.MAX(5)) Counter_Minute_TENS(.en(carryOutMinuteUnit),.clk(clk),.rst_n(resetF),.load(load),.loadedUnit(z_min_in),.resultedUnit(MinuteResultedTens), .carryOut(carryOutMinuteTens));

	Counter#(.WIDTH(4),.MAX(9)) Counter_Hour_UNIT(.en(carryOutMinuteTens & carryOutMinuteUnit),.clk(clk),.rst_n(resetF),.load(load),.loadedUnit(u_hour_in),.resultedUnit(HourResultedUnit), .carryOut(carryOutHourUnit));
	Counter#(.WIDTH(2),.MAX(2)) Counter_Hour_TENS(.en(carryOutMinuteTens & carryOutMinuteUnit & carryOutHourUnit),.clk(clk),.rst_n(resetF),.load(load),.loadedUnit(z_hour_in),.resultedUnit(HourResultedTens), .carryOut());


endmodule