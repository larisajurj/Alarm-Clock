`timescale 1ns/1ns

module Display(
    input [3:0] clk_u_min_in, [2:0] clk_z_min_in, [3:0] clk_u_hour_in , [1:0] clk_z_hour_in, 
    input [3:0] alarm_u_min_in, [2:0] alarm_z_min_in, [3:0] alarm_u_hour_in , [1:0] alarm_z_hour_in,
    input clk, rst,
    output [7:0] A, [7:0] C 
);
    
    reg [3:0] digit; 
    wire [7:0] toLed; 
    wire [7:0] select;
    assign A = select;
    assign C = toLed;

    RingCounter counter(.clk(clk), .rst(rst), .A(select));
    DigitToLED converter(.digit(digit), .C(toLed));

    always @ (*) begin
        case(select)
            'b01111111: begin
                digit = clk_u_min_in;
            end
            'b10111111: begin
                digit = clk_z_min_in;
            end
            'b11011111: begin
                digit = clk_u_hour_in;
            end
            'b11101111: begin
                digit = clk_z_hour_in;
            end
            'b11110111: begin
                digit = alarm_u_min_in;
            end
            'b11111011: begin
                digit = alarm_z_min_in;
            end
            'b11111101: begin
                digit = alarm_u_hour_in;
            end
            'b11111101: begin
                digit = alarm_z_hour_in;
            end
            'b1111111: begin
                digit = clk_u_min_in;
            end
        default: begin
        end
        endcase
    end

endmodule