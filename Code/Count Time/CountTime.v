`timescale 1ns/1ns
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
	assign resetF = resetF_ff;
	always @ * begin
		reached_final = ((HourResultedTens >= 2'b10) & (HourResultedUnit >= 4'b11) & (MinuteResultedTens >= 3'b101) & (MinuteResultedUnit >=4'b1001));
		resetF_nxt = rst_n & ~reached_final;
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