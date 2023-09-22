`timescale 1ms/1ms
module FSM_program_mode_tb();
//clk of 1s/period
    reg clk_1Hz, clk_100Hz, rst_n, trigger, error_detection, button_signal;
    wire [2:0] seconds_left;
    wire saved;
    wire active_program_mode;
    wire extended_trigger;
    wire extended_error_detection;

    FSM_program_mode test(clk_1Hz, rst_n, extended_trigger, extended_error_detection, button_signal, seconds_left, saved, active_program_mode);
    ExtendPositiveSignals extend(clk_100Hz, rst_n, trigger, extended_trigger);
    ExtendPositiveSignals extend2(clk_100Hz, rst_n, error_detection, extended_error_detection);

    
    initial begin
        clk_1Hz = 1'b0;
        forever #500 clk_1Hz = ~clk_1Hz;
    end

    initial begin
        clk_100Hz = 1'b0;
        forever #5 clk_100Hz = ~clk_100Hz;
    end

    initial begin
        rst_n = 1'b0;
        trigger = 1'b0;
        error_detection = 1'b0;
        button_signal = 1'b0;
        //test1
        //out of reset, no trigger
        #500;
        rst_n = 1'b1;
        #5000;
        //test2
        //trigger
        trigger = 1'b1; //if trigger is too short, it won't e detected
        #1000;
        trigger = 1'b0;
        #10000;

        //test3
        //trigger and multiple button signals
        trigger = 1'b1;
        #1000;
        trigger = 1'b0;
        #2400;
        button_signal = 1'b1; 
        #50;
        button_signal = 1'b0;
        #2600;
        button_signal = 1'b1;
        #600;
        button_signal = 1'b0;
        #2000;
        button_signal =1'b1;
        #1400;
        button_signal =1'b0;
        #6000;

        //test 4
        //short trigger
        trigger = 1'b1;
        #300;
        trigger = 1'b0;
        #3000;

        //test 5
        error_detection = 1'b1;
        #20;
        error_detection = 1'b0;
        #3000;
        
        //test 6
        //error detection
        trigger = 1'b1;
        #1000;
        trigger = 1'b0;
        #300;
        error_detection = 1'b1;
        #500;
        error_detection = 1'b0;
        #5000;
        $finish();
    end
endmodule