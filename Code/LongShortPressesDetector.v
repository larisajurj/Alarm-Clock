`timescale 1ms/1ms
/*
    primim un clock cu perioada 1 ms
    se considera o apasare actionarea butonului pt cel putin 10 ms
    daca butonul este actionat mai mult de 500ms, atunci o consideram "apasare lunga"
*/
module LongShortPressesdetector(
    input clk_1kHz, rst,
    input plus_button, minus_button
    output signal
);
    localparam[1:0] STATE_IDLE  = 2'd0,
                    STATE_PULSE_SHORT_PRESS = 2'd1,
                    STATE_SHORT_PRESS   = 2'd2,
                    STATE_LONG_PRESS   = 2'd3;

    reg [1:0] state_ff, state_nxt;
    reg signal_ff;
    assign signal = signal_ff;

    always @(*) begin
        
    end   

    always @ (posedge clk or posedge rst) begin
		if(rst) begin
    	end else begin
   		end
	end
endmodule