/*
    Uses the LSPD FSM to get the correct signals for both minus and plus button. 
    Outputs an overlap between the signals.
    It also sets the increment_positivity.
*/
module LongShortPressesDetector(
    input clk_100Hz, rst_n,
    input plus_button, minus_button,
    output signal, increment_positivity
);
    wire signal_minus; wire signal_plus;
    wire active_minus; wire active_plus;

    assign signal = signal_plus | signal_minus;
    assign increment_positivity = (active_minus) ? 1'b1 : 1'b0;//0 for plus, 1 for minus 

    LSPD_FSM plus_FSM(clk_100Hz, rst_n, plus_button, signal_plus, active_plus);
    LSPD_FSM minus_FSM(clk_100Hz, rst_n, minus_button, signal_minus, active_minus);

endmodule