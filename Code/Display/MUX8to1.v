module MUX8to1(
    input [3:0] clk_u_min_in, [2:0] clk_z_min_in, [3:0] clk_u_hour_in , [1:0] clk_z_hour_in, 
    input [3:0] alarm_u_min_in, [2:0] alarm_z_min_in, [3:0] alarm_u_hour_in , [1:0] alarm_z_hour_in,
    input [7:0] SEL_digit, 
    input SW_alarm,
    output [3:0] digit
);
    reg [3:0] mux_digit;
    assign digit = mux_digit;
    always @ (SEL_digit) begin
        case (SEL_digit)
            'b01111111 : begin
                mux_digit <= clk_u_min_in;
            end
            'b10111111 : begin 
                mux_digit <= clk_z_min_in;
            end
            'b11011111 : begin
                mux_digit <= clk_u_hour_in;
            end
            'b11101111 : begin
                mux_digit <= clk_z_hour_in;
            end
            'b11110111 : begin
                if(SW_alarm)
                    mux_digit <= alarm_u_min_in;
                else
                    mux_digit <= d'A;
            end 
            'b11111011: begin
                if(SW_alarm)
                   mux_digit <= alarm_z_min_in;
                else
                    mux_digit <= d'A;
            end
            'b11111101: begin
                if(SW_alarm)
                   mux_digit <= alarm_u_hour_in;
                else
                    mux_digit <= d'A;
            end 
            'b11111110: begin
                if(SW_alarm)
                   mux_digit <= alarm_z_hour_in;
                else
                    mux_digit <= d'A;
            end 
            'b11111111: begin
            end 

        endcase
    end 
endmodule