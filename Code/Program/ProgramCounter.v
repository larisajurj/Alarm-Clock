`timescale 1ms/1ms
/*
    Counter starting from startUnit until MAX.
    En is active while program mode is active.
    Should increment/decrement on clk posedge.
    If we reach MAX or ZERO, we send a carry_out_positive or carry_out_negative.
    Should be loaded before en is active..
*/
module ProgramCounter#(parameter MAX = 9, parameter WIDTH = 4)(
    input clk, rst_n, add, subtract, en,
    input [WIDTH-1:0] startUnit,
    output carry_out_negative, carry_out_positive,
    output [WIDTH-1:0] resultedUnit
);
    reg [WIDTH-1:0] resultedUnit_nxt, resultedUnit_ff;
	reg carry_out_negative_nxt, carry_out_negative_ff;
    reg carry_out_positive_nxt, carry_out_positive_ff;

	assign resultedUnit = resultedUnit_ff ;
	assign carry_out_negative = carry_out_negative_ff;
    assign carry_out_positive = carry_out_positive_ff;

    always @ (*) begin
        $display("detected a change", $time);
        //nu se da update la nxt = ff inainte de ff = nxt
        resultedUnit_nxt = resultedUnit_ff;
		carry_out_negative_nxt = carry_out_negative_ff;
        carry_out_positive_nxt = carry_out_positive_ff;
        if(en) begin
            if(add)begin
                $display("add", $time);
                if(resultedUnit_ff >= MAX) begin 
                    resultedUnit_nxt       = 'b0;
                    carry_out_positive_nxt = 1'b0;
                end else begin
                    resultedUnit_nxt       = resultedUnit_ff + 'b1;
                    carry_out_positive_nxt = 1'b1;
                end
            end else if(subtract) begin
                $display("subtract", $time);
                if(resultedUnit_ff <= 'b0) begin 
                    resultedUnit_nxt       = 'b0;
                    carry_out_negative_nxt = 1'b0;
                end else begin
                    resultedUnit_nxt       = resultedUnit_ff - 'b1;
                    carry_out_negative_nxt = 1'b0;
                end
            end 
		end
    
    end

    always @ (posedge clk or negedge rst_n) begin
		if(~rst_n) begin
      		resultedUnit_ff <= startUnit;
            carry_out_negative_ff <= 'b0;
            carry_out_positive_ff <= 'b0;
    	end else begin 
      		resultedUnit_ff <= resultedUnit_nxt;
			carry_out_negative_ff <= carry_out_negative_nxt;
            carry_out_positive_ff <= carry_out_positive_nxt;
            $display("now changing ff to nxt ", $time);
   		end
	end



endmodule