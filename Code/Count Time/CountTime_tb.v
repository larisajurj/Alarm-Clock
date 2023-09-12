`timescale 1ms/1ms

module CountTime_tb();
    reg sw_on, clk,load;

    wire [3:0] u_min_out;
    wire [2:0] z_min_out;
    wire [3:0] u_hour_out;
    wire [1:0] z_hour_out;
    //rst_n
    //cazuri inafara intervalului
    //cazul de carry out dupa load
    CountTime testCount(.clk(clk), .rst_n(sw_on), .en(sw_on), .load(load),
                        .u_min_in(4'd3), .z_min_in(3'd5), .u_hour_in(4'd8) , .z_hour_in(2'd2),
                        .u_hour_out(u_hour_out), .u_min_out(u_min_out), .z_hour_out(z_hour_out), .z_min_out(z_min_out));
   
    initial begin
        clk = 0;
        forever #500 clk = !clk;
    end

    initial begin
        sw_on = 1'b0;
        load = 1'b0;
        #1000 sw_on = 1'b1;
        #3000;
        load = 1'b1;
        #1000 load = 1'b0;
        #50000;
        load = 1'b1;
        #1000 load = 1'b0;
        #6000;
        sw_on = 1'b0;
        #5000;

        $finish();
    end
endmodule