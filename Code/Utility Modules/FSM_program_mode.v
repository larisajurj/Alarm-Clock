/*
    We have two states: IDLE and ACTIVE;
    The tigger moves the state from IDLE to ACTIVE
    ACTIVE STATE:
        - enables the counter and resets it if an error is detected.
        - if it gets a saved signal and the trigger is not active, it goes back to IDLE 
    counter_rst resets the counter if we get an active button signal or a rst_n.
*/

module FSM_program_mode(
    input clk, rst_n, trigger, error_detection, button_signal,
    output [2:0] seconds_left,
    output saved, active_program_mode
);
    localparam STATE_IDLE = 1'b0, STATE_ACTIVE = 1'b1; 
    reg state_ff, state_nxt;
    reg active_ff, active_nxt;
    wire counter_rst;

    assign counter_rst = rst_n & (~button_signal);
    assign active_program_mode = active_ff; 
    
    FiveSecondsCounter counter(clk, counter_rst, active_ff, seconds_left, saved);
    
    always @ (*) begin
        state_nxt  = state_ff;
        active_nxt = active_ff;

        case(state_ff)
            STATE_IDLE: begin
                if(trigger) begin
                    state_nxt  = STATE_ACTIVE;
                    active_nxt = 1'b1;
                end
            end
            STATE_ACTIVE:begin
                if(error_detection) begin
                    state_nxt = STATE_IDLE;
                    active_nxt = 1'b0;
                end else if((saved) & (~trigger)) begin
                     state_nxt = STATE_IDLE;
                     active_nxt = 1'b0;
                end
            end
            default: state_nxt = STATE_IDLE;
        endcase
    end

    always @ (posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            state_ff  = STATE_IDLE;
            active_ff = 1'b0;
        end else begin
            state_ff  = state_nxt;
            active_ff = active_nxt;
        end
    end

endmodule