`timescale 1ms/1ms
/*
    primim un clock cu perioada 1 ms
    se considera o apasare actionarea butonului pt cel putin 10 ms
    daca butonul este actionat mai mult de 500ms, atunci o consideram "apasare lunga"
*/
module LongShortPressesDetector(
    input clk_1kHz, rst,
    input plus_button, minus_button
    output signal, increment_positivity
);
    localparam[1:0] STATE_IDLE                   = 2'd0,
                    STATE_INCREMENT_SHORT_PRESS  = 2'd1,
                    STATE_SHORT_PRESS            = 2'd2,
                    STATE_LONG_PRESS             = 2'd3;

    reg [1:0] state_ff, state_nxt;
    reg [7:0] count_ff, count_nxt;
    reg signal_ff, signal_nxt;
    reg sel_ff, sel_nxt;

    SingleClockDivider#(.width(8), MAX(500)) Clock_05Hz(.clk(clk_1kHz), .rst(rst), .en(1'b1), .div_clk(div_clk));
    assign signal = (sel_ff) ? div_clk : signal_ff;

    always @(*) begin
        state_nxt = state_ff; //!!
        count_ff = count_nxt;
        sel_ff = sel_nxt;
        case(state_ff)
            STATE_IDLE: begin
                count_nxt = 8'b0;
                sel_nxt = 1'b0;
                signal_nxt = 1'b0;
                if(plus_button | minus_button) begin
                    state_nxt = STATE_INCREMENT_SHORT_PRESS;
                end
            end
            STATE_INCREMENT_SHORT_PRESS: begin
                if(plus_button | minus_button) begin
                    state_nxt  = STATE_SHORT_PRESS;
                    count_nxt  = 8'b1;
                    signal_nxt = 1'b1; //one single pulse
                end else begin
                    state_nxt = STATE_IDLE;
                end
            end
            STATE_SHORT_PRESS: begin
                signal_nxt = 1'b0;
                if(plus_button | minus_button) begin
                    count_nxt = count_ff + 8'b1;
                    if(count_nxt === 8'd10) begin //will be 250 actually
                        state_nxt = STATE_LONG_PRESS;
                    end
                end else begin
                    state_nxt = STATE_IDLE;
                end
            end
            STATE_LONG_PRESS: begin
                sel_nxt = 1'b1;
                if(plus_button | minus_button) begin
                    
                end else begin
                    state_nxt = STATE_IDLE;
                end
            end
            default: begin
            end
        endcase
    end   

    always @ (posedge clk or posedge rst) begin
		if(rst) begin
            state_ff  <= STATE_IDLE;
            count_ff  <= 0;
            sel_ff    <= 0;
            signal_ff <= 0;
    	end else begin
            state_ff  <= state_nxt;
            count_ff  <= count_nxt;
            state_ff  <= state_nxt;
            signal_ff <= signal_nxt;
   		end
	end
endmodule