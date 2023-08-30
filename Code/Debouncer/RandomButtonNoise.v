`timescale 1us/1us
module randomize_button_noise(
    input clk_fast, rst,
    output randomized_d
);
    reg  d_ff, d_nxt;
    assign randomized_d = d_ff;


    reg [5:0] disturbance_time_slot; //max 30 ms
    reg [5:0] disruptions;    //how many distruptions in length_duration? 
    reg [5:0] length_of_disruptions = 6'b0; //how long does this singular disruption last? 
    reg [5:0] count_time_ff; //to figure out when the time slot has passed
    reg distruption_active_ff = 1'b0;
    reg [5:0] count_disruptions_length_ff;
    reg [5:0] count_disruptions_ff;

    reg [2:0] state_ff, state_nxt;
    reg [5:0] count_time_nxt, count_disruptions_length_nxt, count_disruptions_nxt; //to figure out when the time slot has passed
    reg distruption_active_nxt = 1'b0;


    localparam[2:0] STATE_IDLE              = 3'd0,
                    STATE_GET_RANDOMS       = 3'd1,
                    STATE_START_DISTURBANCE = 3'd2,
                    STATE_DISTURBANCE       = 3'd3,
                    STATE_SOLID_PRESS       = 3'd4;

    always @ (*) begin
        state_nxt =                    state_ff;
        count_time_nxt =               count_time_ff;
        count_disruptions_length_nxt = count_disruptions_length_ff;
        count_disruptions_nxt =        count_disruptions_ff;
        d_nxt =                        d_ff;

        case(state_ff)
        STATE_IDLE: begin
            if(d_ff == 1'b1) begin
                state_nxt = STATE_GET_RANDOMS;
                d_nxt = 1'b1;
            end else begin
                state_nxt = STATE_IDLE;
            end
        end
        STATE_GET_RANDOMS: begin
            disturbance_time_slot = $urandom_range(10,30);
            disruptions = $urandom_range(5,15);
            d_nxt = 1'b1;
            state_nxt = STATE_START_DISTURBANCE;
        end
        STATE_START_DISTURBANCE: begin
            length_of_disruptions = $urandom_range(1,5);
            if(length_of_disruptions > disturbance_time_slot - count_time_ff) begin
                state_nxt = STATE_SOLID_PRESS;
            end else begin
                count_time_nxt = count_time_ff + 'b1;
                d_nxt = 1'b0;
                count_disruptions_length_nxt = 'b1;
                state_nxt = STATE_DISTURBANCE;
            end
        end
        STATE_DISTURBANCE: begin
            if(count_time_ff >= disturbance_time_slot) begin //if the time has passed
                state_nxt = STATE_SOLID_PRESS;
                d_nxt = 1'b1;
            end else if((count_disruptions_length_ff >= length_of_disruptions) && (count_disruptions_ff < disruptions)) begin //if we have more distruptions to generate
                state_nxt = STATE_START_DISTURBANCE;
                d_nxt = 1'b1;
            end else begin
                d_nxt = 1'b0;   //else we continue the disturbance
                count_time_nxt = count_time_ff + 'b1;
                count_disruptions_length_nxt = count_disruptions_length_ff + 'b1;
            end
        end
        STATE_SOLID_PRESS: begin
            d_nxt = 1'b1;
        end
        default: begin
	    end
        endcase
    end

    always @(posedge clk_fast or posedge rst) begin
        if(rst) begin
            state_ff <= STATE_IDLE; 
            count_time_ff <=               6'b0;
            count_disruptions_length_ff <= 6'b0;
            count_disruptions_ff <=        6'b0;
            d_ff <=                        1'b1;
        end else begin
            state_ff <=                    state_nxt;
            count_time_ff <=               count_time_nxt;
            count_disruptions_length_ff <= count_disruptions_length_nxt;
            count_disruptions_ff <=        count_disruptions_nxt;
            d_ff <=                        d_nxt;
        end
    end
endmodule
