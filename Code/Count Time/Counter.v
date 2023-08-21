module Counter#(parameter MAX = 9, parameter WIDTH = 3)(
    input clk, rst, en, 
    output [WIDTH-1:0] resultedUnit,
	output carryOut
);

    reg [WIDTH-1:0] resultedUnit_nxt, resultedUnit_ff;
	reg carryOut_nxt, carryOut_ff;
	assign resultedUnit = resultedUnit_ff ;
	assign carryOut = carryOut_ff;

	always @(*) begin
		resultedUnit_nxt = resultedUnit_ff;
		if(en) begin
			if(resultedUnit_ff == MAX) begin
				resultedUnit_nxt = 'b0;
			end else begin
				resultedUnit_nxt = resultedUnit_ff + 1'b1;
			end

			if(resultedUnit_ff == MAX-1) begin
				carryOut_nxt = 1'b1;
			end else begin
				carryOut_nxt = 1'b0;
			end
		end
	end
	
	always @ (posedge clk or posedge rst) begin
		if(rst) begin
      		resultedUnit_ff <= 'b0;
    	end else begin
      		resultedUnit_ff <= resultedUnit_nxt;
			carryOut_ff <= carryOut_nxt;
   		end
	end
endmodule