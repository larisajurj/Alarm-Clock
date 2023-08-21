`timescale 1ns/1ns
module CountTime(
    input clk, rst, sel_program,
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
	assign resetF = resetF_ff;
	always @ * begin
		resetF_nxt = rst | ((HourResultedTens == 'b10) & (HourResultedUnit == 'b11) & (carryOutMinuteTens & carryOutMinuteUnit));
	end
	always @ (posedge clk or posedge rst) begin
		if(rst) begin
      		resetF_ff <= 'b1;
    	end else begin
			resetF_ff <= resetF_nxt;
   		end
	end

	Counter#(.WIDTH(4),.MAX(9)) Counter_Minute_UNIT(.en(1'b1),.clk(clk),.rst(resetF),.resultedUnit(MinuteResultedUnit), .carryOut(carryOutMinuteUnit));
	Counter#(.WIDTH(3),.MAX(5)) Counter_Minute_TENS(.en(carryOutMinuteUnit),.clk(clk),.rst(resetF),.resultedUnit(MinuteResultedTens), .carryOut(carryOutMinuteTens));

	Counter#(.WIDTH(4),.MAX(9)) Counter_Hour_UNIT(.en(carryOutMinuteTens & carryOutMinuteUnit),.clk(clk),.rst(resetF),.resultedUnit(HourResultedUnit), .carryOut(carryOutHourUnit));
	Counter#(.WIDTH(2),.MAX(2)) Counter_Hour_TENS(.en(carryOutMinuteTens & carryOutMinuteUnit & carryOutHourUnit),.clk(clk),.rst(resetF),.resultedUnit(HourResultedTens), .carryOut());


endmodule