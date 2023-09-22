`timescale 1ns/1ns
/*
    8 bit ring counter to select  active low Anode
*/
module RingCounter(
    input clk, rst,
    output [7:0] A 
);
    reg [7:0] state_ff, state_nxt;
    assign A = state_ff; 

    localparam[7:0] STATE_D0 =  'b01111111,
                    STATE_D1 =  'b10111111,
                    STATE_D2 =  'b11011111,
                    STATE_D3 =  'b11101111,
                    STATE_D4 =  'b11110111,
                    STATE_D5 =  'b11111011,
                    STATE_D6 =  'b11111101,
                    STATE_D7 =  'b11111110,
                    STATE_OFF = 'b11111111;
    
    always @ (*) begin
        state_nxt = state_ff;
        case(state_ff)
            STATE_D0: begin 
                state_nxt = STATE_D1;
            end
            STATE_D1: begin 
                state_nxt = STATE_D2;
            end
            STATE_D2: begin 
                state_nxt = STATE_D3;
            end
            STATE_D3: begin 
                state_nxt = STATE_D4;
            end
            STATE_D4: begin 
                state_nxt = STATE_D5;
            end
            STATE_D5: begin 
                state_nxt = STATE_D6;
            end
            STATE_D6: begin 
                state_nxt = STATE_D7;
            end
            STATE_D7: begin 
                state_nxt = STATE_D0;
            end
            STATE_OFF: begin 
                state_nxt = STATE_D0;
            end
            default: begin
                state_nxt = STATE_OFF;
            end
        endcase
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            state_ff <= STATE_OFF;
        end else begin
            state_ff <= state_nxt;
        end
    end
endmodule
