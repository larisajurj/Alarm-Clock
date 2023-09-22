/*
	This is a module used to count the IDLE time.
	It works on a 1s/cycle clock and while it is enabled, it counts to MAX and if reached it sends a carry out signal.
	The start value can be loaded using the load input. 
*/
module Counter#(parameter MAX = 9, parameter WIDTH = 3)(
    input clk, rst_n, en, load, 
	input [WIDTH-1:0] loadedUnit, 
    output [WIDTH-1:0] resultedUnit,
	output carryOut
);
 
    reg [WIDTH-1:0] resultedUnit_nxt, resultedUnit_ff;
	reg carryOut_nxt, carryOut_ff;
	assign resultedUnit = resultedUnit_ff ;
	assign carryOut = carryOut_ff;

	always @(*) begin
		resultedUnit_nxt = resultedUnit_ff;
		carryOut_nxt = carryOut_ff;
		
		if(en || load) begin
					resultedUnit_nxt = resultedUnit_ff;
			case(load)
				1'b1:   begin
							resultedUnit_nxt = loadedUnit;
							if(loadedUnit >= MAX)
								carryOut_nxt = 1'b1;
							else
								carryOut_nxt = 1'b0;
						end
				default:begin
							if(resultedUnit_ff >= MAX) begin
								resultedUnit_nxt = 'b0;
								carryOut_nxt = 1'b0;
							end else if(resultedUnit_ff >= MAX-1) begin
								carryOut_nxt = 1'b1;
								resultedUnit_nxt = resultedUnit_ff + 1'b1;
								end else begin
									resultedUnit_nxt = resultedUnit_ff + 1'b1;
										carryOut_nxt = 1'b0;
								end
						end
			endcase
		end
	end
	
	always @ (posedge clk or negedge rst_n) begin
		if(~rst_n) begin
      		resultedUnit_ff <= 'b0;
    	end else begin 
      		resultedUnit_ff <= resultedUnit_nxt;
			carryOut_ff <= carryOut_nxt;
   		end
	end
endmodule