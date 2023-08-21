`timescale 1ns/1ns

module Display_tb();
    reg clk, rst, clk_fast, SW_alarm;
    wire [7:0] A;
    wire [7:0] C;
    wire [3:0] clk_u_min_in;
    wire [2:0] clk_z_min_in;
    wire [3:0] clk_u_hour_in;
    wire [1:0] clk_z_hour_in;
    wire [3:0] alarm_u_min_in;
    wire [2:0] alarm_z_min_in;
    wire [3:0] alarm_u_hour_in;
    wire [1:0] alarm_z_hour_in;
    wire [3:0] digit;

    Display display(.clk_u_min_in(4'd4), .clk_z_min_in(3'd0), .clk_u_hour_in(4'd6), .clk_z_hour_in(2'd2),
                    .alarm_u_min_in(4'd1), .alarm_z_min_in(3'd3), .alarm_u_hour_in(4'd5), .alarm_z_hour_in(2'd1),  
                    .clk(clk_fast), .rst(rst), .A(A), .C(C));
    MUX8to1 mux8to1(.clk_u_min_in(4'd4), .clk_z_min_in(3'd0), .clk_u_hour_in(4'd6), .clk_z_hour_in(2'd2),
                    .alarm_u_min_in(4'd1), .alarm_z_min_in(3'd3), .alarm_u_hour_in(4'd5), .alarm_z_hour_in(2'd1),  
                    .SEL_digit(A), .SW_alarm(SW_alarm),
                    .digit(digit));

    initial begin
        SW_alarm = 0;
        #100 SW_alarm = !SW_alarm;
    end
    initial begin
        clk = 0;
        forever #8 clk = !clk;
    end

    initial begin
        clk_fast = 0;
        forever #2 clk_fast = !clk_fast;
    end


    initial begin
        rst = 1'b1;
        #3 rst = 1'b0;
        #3000;
        $finish();
    end
endmodule