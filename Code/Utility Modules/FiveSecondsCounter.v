/*
    While en is enabled, counts 5 seconds (or 5 posedges if clock is not of 1Hz).
    Outputs the seconds left and saved if we reached 5.
*/
module FiveSecondsCounter(
    input clk, rst_n, en,
    output [2:0] seconds_left, 
    output saved
);
    reg [2:0] count_ff, count_nxt;
    reg saved_ff, saved_nxt;

    assign seconds_left = count_ff;
    assign saved = saved_ff;

    always @ (*) begin
        count_nxt = count_ff;
        saved_nxt = saved_ff;
        saved_nxt = 1'b0;
        if(en) begin
            if(count_ff === 3'b0) begin
                count_nxt = 3'b101;
            end else begin
                count_nxt = count_ff - 3'b1;
            end
            
            if(count_nxt === 3'b0) begin
                saved_nxt = 1'b1;
            end
        end else begin
            count_nxt = 3'b101;
        end
    end 

    always @ (posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            count_ff <= 3'b101;
            saved_ff <= 1'b0;
        end else begin
            count_ff <= count_nxt;
            saved_ff <= saved_nxt;
        end
    end
endmodule