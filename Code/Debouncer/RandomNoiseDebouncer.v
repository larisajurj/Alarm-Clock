`timescale 1ms/1ms
/* Generates random noise for the debouncer to simulate real-like presses */
module randomNoiseDebouncer(
    input clk,
    output d_out
);
    reg [5:0] disturbance_time_slot;
    reg [5:0] disruptions; 
    reg [5:0] length_of_disruptions;
    reg [6:0] random_wait;

    reg d;
    assign d_out = d;
    integer j, k, tests,t,i;
    initial begin
            #1
        tests = $urandom_range(3,10);
        for(i = 0; i < tests; i = i +1) begin
            random_wait = $urandom_range(1,100);
            #(random_wait);
            disturbance_time_slot = $urandom_range(10,30); 
            disruptions = $urandom_range(4,7);
            #1
            d = 1'b1;
            for(j = 0;( j < disruptions )&& (disturbance_time_slot != 0); j = j + 1) begin
                #1
                length_of_disruptions = $urandom_range(1,3);
                d = 1'b1;
                disturbance_time_slot = disturbance_time_slot - 'b1;
                for(k = 0; (k < length_of_disruptions) && (disturbance_time_slot != 0); k = k + 1) begin
                    #1
                    d = 1'b0;
                    disturbance_time_slot = disturbance_time_slot - 'b1;
                end
            end

                #1 d = 1'b1;
                #40; 

            disturbance_time_slot = $urandom_range(10,30); 
            disruptions = $urandom_range(4,7);
            #1
            d = 1'b1;
            for(j = 0;( j < disruptions )&& (disturbance_time_slot != 0); j = j + 1) begin
                #1
                length_of_disruptions = $urandom_range(1,3);
                d = 1'b1;
                disturbance_time_slot = disturbance_time_slot - 'b1;
                for(k = 0; (k < length_of_disruptions) && (disturbance_time_slot != 0); k = k + 1) begin
                    #1
                    d = 1'b0;
                    disturbance_time_slot = disturbance_time_slot - 'b1;
                end
            end
                #1 d = 1'b0;
        end
    end
endmodule