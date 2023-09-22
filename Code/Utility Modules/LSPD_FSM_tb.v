`timescale  1ms/1ms
module LSPD_FSM_tb();
    reg clk_100Hz, rst_n, button;
    wire signal;
    wire active;
    localparam[3:0] one_clock = 4'd10;

    LSPD_FSM test(clk_100Hz, rst_n, button, signal, active);

    initial begin
        clk_100Hz = 1'b0;
        forever #5 clk_100Hz = ~clk_100Hz;
    end

    initial begin
               //reset state
        button = 1'b0;
        rst_n = 1'b0;
        #(one_clock);
        rst_n = 1'b1;
        #(one_clock);
        
        //short press +
        button = 1'b1;
        #(30*one_clock);
        button = 1'b0;
        #(50*one_clock);
        
        //long press -
        button = 1'b1;
        #(200*one_clock);
        button = 1'b0;
        #(50*one_clock);
        
        //short press +-
        button = 1'b1;
        button = 1'b1;
        #(90*one_clock);

        

        $finish();

    end
endmodule