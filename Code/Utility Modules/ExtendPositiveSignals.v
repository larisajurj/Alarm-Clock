/*
    Extends every positive signal to last 1s
*/
module ExtendPositiveSignals(
    input clk_100Hz, rst_n, signal,
    output new_signal
);
    localparam STATE_IDLE   = 1'b0,
               STATE_ACTIVE = 1'b1;

    reg state_ff, state_nxt;
    reg [6:0] count_ff, count_nxt;
    reg signal_ff, signal_nxt;
    assign new_signal = signal_ff;

    always @ (*) begin
        count_nxt  = count_ff;
        signal_nxt = signal_ff;
        state_nxt  = state_ff;
        
        case(state_ff)
            STATE_IDLE : begin
                if(signal) begin
                    state_nxt = STATE_ACTIVE;
                    signal_nxt = 1'b1;
                end
            end
            STATE_ACTIVE : begin
                if(signal) begin
                    count_nxt = 7'b1;
                end else begin
                    if(count_ff == 7'd100) begin

                        state_nxt = STATE_IDLE;
                        count_nxt = 7'b0;
                        signal_nxt = 7'b0;
                    end else
                        count_nxt = count_ff + 7'b1;
                end
            end
        endcase
    end

    always @ (posedge clk_100Hz or negedge rst_n) begin
        if(~rst_n) begin
            count_ff = 7'b0;
            signal_ff = 1'b0;
            state_ff = STATE_IDLE;
        end else begin
            state_ff  = state_nxt;
            count_ff  = count_nxt;
            signal_ff = signal_nxt;
        end
    end
endmodule