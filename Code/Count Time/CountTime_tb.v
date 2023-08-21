`timescale 1ns/1ns

module CountTime_tb();
    reg clk, rst;
    wire [7:0] A;
    wire [7:0] C;
    wire [3:0] u_min_out;
    wire [2:0] z_min_out;
    wire [3:0] u_hour_out;
    wire [1:0] z_hour_out;
    wire divided_clk;

    ClockDivider ClockDivider_1HZ(.clk(clk), .rst(rst), .clk_1Hz(divided_clk), .clk_1kHz()); 
    CountTime testCount(.clk(clk), .rst(rst), .sel_program(1'b1),
                        .u_min_in(), .z_min_in(), .u_hour_in() , .z_hour_in(),
                        .u_hour_out(u_hour_out), .u_min_out(u_min_out), .z_hour_out(z_hour_out), .z_min_out(z_min_out));
   
    initial begin
        clk = 0;
        forever #8 clk = !clk;
    end

    initial begin
        rst = 1'b1;
        #3 rst = 1'b0;
        #300;
        $finish();
    end
endmodule