`timescale 1ns/1ns
/*
    Module that converts the binary digits into the respective catode values
*/
module DigitToLED(
    input [3:0] digit,
    output [7:0] C
);
    reg [7:0] toLed;
    assign C = toLed;

    always @ (*) begin
        case(digit)
            'd0:  toLed = 'b00000011;
            'd1:  toLed = 'b10011111;
            'd2:  toLed = 'b00100101;
            'd3:  toLed = 'b00001101;
            'd4:  toLed = 'b10011001;
            'd5:  toLed = 'b01001001;
            'd6:  toLed = 'b01000001;
            'd7:  toLed = 'b00011011;
            'd8:  toLed = 'b00000001;
            'd9:  toLed = 'b00001001;
            'd10: toLed = 'b11111111; //closed display 
                          //ABCDEFGP
        default: begin
        end
        endcase
    end
endmodule
