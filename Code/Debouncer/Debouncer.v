`timescale 1us/1us
module debouncer_tb_2();
    reg  clk_fast;
    reg  clk;

    reg  rst;
    reg  d;
    wire q;

    reg [5:0] distruption_time_slot; //max 30 ms
    reg [5:0] distruptions_count;    //how many distruptions in length_duration? 
    reg [5:0] length_of_distruption = 6'b0; //how long does this singular distruption last? 
    reg [5:0] cycles_passed; //to figure out when the time slot has passed
    reg [8:0] clear_press_time_slot;
    reg distruption_active = 1'b0;
    reg [5:0] cycles_passed_length_of_distruption;
    reg [5:0] cycles_passed_distruptions_count;

    debounce d1(clk,rst,d,q);
    initial begin
        clk = 1'b0;
        forever #10000 clk=!clk; //clock of 20ms/period
    end
    initial begin
        clk_fast = 1'b1;
        forever #500 clk_fast=!clk_fast; //clock of 1kHz
    end

    initial begin
        rst = 1'b1;
        d = 1'b0;
        #1000 rst = 1'b0;
    end
    


    


    
    
endmodule
