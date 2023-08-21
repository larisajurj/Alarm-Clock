`timescale 1ms/1ms
module debounce (input clk,rst,d, output q);  
  // internal signal definition
  reg val_d1, val_d2, val_save;
  
  assign q = val_save;
  
  always @(posedge clk or posedge rst) begin
    if(rst) begin
      val_d1   <= 1'b0;
      val_d2   <= 1'b0;
      val_save <= 1'b0;
    end else begin
      val_d1 <= d;
      val_d2 <= val_d1;
      if(val_d2 == val_d1) begin
        val_save <= val_d1;
      end
    end
  end
endmodule

//-------------------------------
//--- Code your testbench here --
//-------------------------------

`timescale 1ns/1ns
module ();
  reg  clk;
  reg  rst;
  reg  d;
  wire q;
  debounce d1(clk,rst,d,q);
  initial begin
    clk = 1'b0;
    forever #10 clk=!clk;
  end
  initial begin
    rst = 1'b1;
    d   = 1'b0;
    #1 rst = 1'b0;
    #3 d=1;
    #1 d=0;
    #1 d=1;
    #1 d=0;
    #1 d=1;
    #1 d=0;
    #1 d=1;
    #1 d=0;
    #2 d=1;
    #1 d=0;
    #1 d=1;
    #26 d=0;
    #4 d=1;
	#30 d=0;
    #2 d=1;
    #1 d=0;
    #1 d=1;
    #1 d=0;
    #1 d=1;
    #1 d=0;
    #1 d=1;
    #3 d=0;
    #100;
    $finish();
  end
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
endmodule
