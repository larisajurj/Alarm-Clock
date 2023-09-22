`timescale 1ms/1ms
module ProgramCounter_tb();
    reg signal, rst_n, add, subtract, en;
    reg [3:0] start_unit = 4'b0101;
    wire carry_out_negative;
    wire carry_out_positive;
    wire [3:0] resulted_unit;

    ProgramCounter#(.WIDTH(4), .MAX(9)) test(signal, rst_n, add, subtract, en, start_unit, carry_out_negative, carry_out_positive, resulted_unit);


    initial begin
        //generate long and short presses
        add = 1'b0;
        subtract = 1'b0;
        signal = 1'b0;
        #1000;
        //add
        add = 1'b1;
        signal = 1'b1;
        #20;
        add = 1'b0;
        signal = 1'b0;
        #500;
        subtract = 1'b1;
        signal = 1'b1;
        #100;
        signal = 1'b0;
        #100
        signal = 1'b1;
        #100;
        signal = 1'b0;
        subtract = 1'b0;
        #1000
        signal = 1'b0;
        #500;
        add = 1'b1;
        signal = 1'b1;
        #1000;
        signal = 1'b0;
        #5000;
        $finish();
    end
    initial begin
        rst_n = 1'b0;
        subtract = 1'b0;
        en = 1'b0;
        #500;
        rst_n = 1'b1;
        en = 1'b1;
        #9000;

    end
endmodule