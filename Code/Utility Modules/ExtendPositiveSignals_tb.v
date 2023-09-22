`timescale 1ms/1ms

module ExtendPositiveSignals_tb();
    reg clk, rst_n, signal;
    wire new_signal;

    ExtendPositiveSignals extend(clk, rst_n, signal, new_signal);
    
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst_n = 1'b0;
        signal = 1'b0;
        #10;
        rst_n = 1'b1;
        #30;
        signal = 1'b1;
        #20;
        signal = 1'b0;
        #700;
        signal = 1'b1;
        #200;
        signal = 1'b0;
        #1000;
        signal = 1'b1;
        #20;
        signal = 1'b0;
        #5000;

        $finish();
    end
endmodule