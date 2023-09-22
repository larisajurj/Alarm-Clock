`timescale 1ms/1ms
/*
    primim un clock cu perioada 10 ms
    se considera o apasare actionarea butonului un semnal de la debouncer
    daca butonul este actionat mai mult de 1 secunda, atunci o consideram "apasare lunga"
    
    cazul de apasare scurta: o singura incrementare
    cazul de apasare lunga : o incrementare la 240 ms
*/
module LSPD_FSM(
    input clk_100Hz, rst_n,
    input button,
    output signal, active
);

    localparam[1:0] STATE_IDLE                   = 2'd0,
                    STATE_INCREMENT_SHORT_PRESS  = 2'd1,
                    STATE_SHORT_PRESS            = 2'd2,
                    STATE_LONG_PRESS             = 2'd3;

    reg [1:0] state_ff, state_nxt;
    reg [9:0] count_ff, count_nxt;
    reg signal_ff, signal_nxt;
    reg sel_ff, sel_nxt;
    reg active_ff, active_nxt;
    // max is 100
    SingleClockDivider#(.width(8), .MAX(25)) Clock_05Hz(.clk(clk_100Hz), .rst_n(rst_n), .en(1'b1), .div_clk(div_clk));
    assign signal = (sel_ff) ? div_clk : signal_ff;
    assign active = active_ff; //0 is add, 1 is subtract

    always @(*) begin
        state_nxt = state_ff; 
        count_nxt = count_ff;
        sel_nxt = sel_ff;
        signal_nxt = signal_ff;
        active_nxt = active_ff;
        
        case(state_ff)
            STATE_IDLE: begin
                //count_nxt = 10'b0;
                sel_nxt = 1'b0;
                signal_nxt = 1'b0;
                active_nxt = 1'b0;
                if(button) begin
                    state_nxt = STATE_INCREMENT_SHORT_PRESS;
                    count_nxt = 10'b1;
                end
            end
            STATE_INCREMENT_SHORT_PRESS: begin
                signal_nxt = 1'b1; //one single pulse
                active_nxt = 1'b1;
                if(button) begin
                    state_nxt  = STATE_SHORT_PRESS;
                    count_nxt = count_ff + 10'b1;
                end else begin
                    state_nxt = STATE_IDLE;
                    count_nxt = 10'b0;
                end
            end
            STATE_SHORT_PRESS: begin
                //#120 
                signal_nxt = 1'b0;
                if(button) begin
                    count_nxt = count_ff + 10'b1;
                    //state_nxt = STATE_SHORT_PRESS;
                    if(count_nxt == 10'd100) begin //will be 100 actually
                        state_nxt = STATE_LONG_PRESS;
                    end
                end else begin
                    count_nxt = 10'b0;
                    state_nxt = STATE_IDLE;
                end
            end
            STATE_LONG_PRESS: begin
                sel_nxt = 1'b1;
                signal_nxt = 1'b1;
                if(~button) begin
                    state_nxt = STATE_IDLE;
                end
            end
            default: begin
                state_nxt = STATE_IDLE;
            end
        endcase
    end   

    always @ (posedge clk_100Hz or negedge rst_n) begin
		if(~rst_n) begin
            state_ff      <= STATE_IDLE;
            count_ff      <= 10'b0;
            sel_ff        <= 1'b0;
            signal_ff     <= 1'b0;
            active_ff     <= 1'b0;
    	end else begin
            state_ff      <= state_nxt;
            count_ff      <= count_nxt;
            sel_ff        <= sel_nxt;
            signal_ff     <= signal_nxt;
            active_ff     <= active_nxt;
   		end
	end
endmodule