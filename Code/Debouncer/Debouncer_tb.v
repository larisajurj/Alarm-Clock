`timescale 1ms/1ms
module debouncer_tb();
    wire d1; wire d2; wire d3; wire d4; wire d5;
    reg clk, rst_n;
    wire q1; wire q2; wire q3; wire q4; wire q5;

    randomNoiseDebouncer random_presses1(clk, d1);
    randomNoiseDebouncer random_presses2(clk, d2);
    randomNoiseDebouncer random_presses3(clk, d3);
    randomNoiseDebouncer random_presses4(clk, d4);
    randomNoiseDebouncer random_presses5(clk, d5);

    Debouncer deb(clk, rst_n,
                 d1, d2, d3, d4, d5,
                 q1, q2, q3, q4, q5);

    initial begin
        clk = 1'b0;
        forever #5 clk=!clk; //clock of 10ms/period
    end

    initial begin
        rst_n = 1'b0;
        #1 rst_n = 1'b1;
        #1000;
        $finish();
    end
endmodule