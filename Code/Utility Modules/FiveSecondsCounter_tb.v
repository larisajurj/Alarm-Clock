`timescale 1ms/1ms
module FiveSecondsCounter_tb();
    reg en, clk_1Hz, rst_n, restart;
    wire [2:0] seconds_left;
    wire saved;

    FiveSecondsCounter test(clk_1Hz, rst_n, en, seconds_left, saved);

    initial begin 
        clk_1Hz = 1'b0;
        forever #500 clk_1Hz = ~clk_1Hz;
    end

    initial begin
        rst_n = 1'b0;
        en = 1'b0;
        #500 rst_n = 1'b1;
        #500;
        en = 1'b1;
        #6000;
        rst_n = 1'b0;
        #1000;
        rst_n = 1'b1;
        #3728;
        en = 1'b0;
        #7000;
        $finish();
    end
endmodule