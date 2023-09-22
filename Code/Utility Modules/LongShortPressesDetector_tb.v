`timescale 1ms/1ms
module LongShortPressesdetector_tb();
    reg clk_100Hz, rst_n;
    wire signal;
    reg d_plus_out;
    reg d_minus_out;
    wire sign;
    localparam[3:0] one_clock = 4'd10;

    LongShortPressesDetector lspd(clk_100Hz, rst_n, d_plus_out, d_minus_out, signal, sign);

    initial begin
        clk_100Hz = 1'b0;
        forever #5 clk_100Hz = ~clk_100Hz;
    end

    initial begin
        //reset state
        d_plus_out = 1'b0;
        d_minus_out = 1'b0;
        rst_n = 1'b0;
        #(one_clock);
        rst_n = 1'b1;
        #(one_clock);
        
        //short press +
        d_plus_out = 1'b1;
        #(3*one_clock);
        d_plus_out = 1'b0;
        #(5*one_clock);
        
        //long press -
        d_minus_out = 1'b1;
        #(20*one_clock);
        d_minus_out = 1'b0;
        #(5*one_clock);
        
        //short press +-
        d_plus_out = 1'b1;
        d_minus_out = 1'b1;
        #(9*one_clock);
        d_plus_out = 1'b0;
        d_minus_out = 1'b0;
        #(5*one_clock);
        
        //plus press and right after minus press
        d_plus_out = 1'b1;
        #(9*one_clock);
        d_plus_out = 1'b0;
        d_minus_out = 1'b1;
        #(5*one_clock);
        d_minus_out = 1'b0;
        #(5*one_clock);

        $finish();

    end

   
endmodule
