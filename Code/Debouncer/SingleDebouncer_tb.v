`timescale 1ms/1ms
module SingleDebouncer_tb();
    reg  clk;
    reg rst_n;
    wire q;
    reg d;

    reg [5:0] disturbance_time_slot;
    reg [5:0] disruptions; 
    reg [5:0] length_of_disruptions;
    

    integer j, k, tests,t;


    debounce d1(clk,rst_n,d,q);

    initial begin
        clk = 1'b0;
        forever #5 clk=!clk; //clock of 10ms/period
    end

    initial begin
        rst_n = 1'b1;
        #1 rst_n = 1'b0;
        for(tests = 0; tests < 5; tests = tests + 1)begin
            #1
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

           // for(t = 0; t < 40; t = t + 1) begin
                #1 d = 1'b1;
            //end
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

            //or(t = 0; t < 30; t = t + 1) begin
                #1 d = 1'b0;
                #30;
            //end 
        end
        $finish();
        
    end
endmodule