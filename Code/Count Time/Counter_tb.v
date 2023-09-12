`timescale 1ms/1ms

module counter_tb();
    reg clk, rst_n, load;
    wire [3:0]resultedUnit;
    wire [3:0]resultedUnitHour;

    wire carryOut;

    Counter#(.WIDTH(4),.MAX(9)) Counter_Minute_UNIT(.en(1'b1),.clk(clk),.rst_n(rst_n),.load(load),.loadedUnit(4'd9), 
                                                    .resultedUnit(resultedUnit), .carryOut(carryOut));
    Counter#(.WIDTH(4),.MAX(5)) Counter_Minute(.en(carryOut),.clk(clk),.rst_n(rst_n),.load(load),.loadedUnit(4'd3), 
                                                    .resultedUnit(resultedUnitHour), .carryOut());

    initial begin
        clk = 0;
        forever #500 clk = !clk;
    end   

    initial begin
        rst_n = 1'b0;
        load = 1'b0;
        #1000 rst_n = 1'b1;
        #3000;
        load = 1'b1;
        #1000 load = 1'b0;
        #50300;
        load = 1'b1;
        #1000 load = 1'b0;
        #6000;
        rst_n = 1'b0;
        #5000;

        $finish();
    end
endmodule