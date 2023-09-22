`timescale 1us/1us
/*
    TOP of all debouncers
*/
module Debouncer(
    input clk, rst_n,
    input plus_button, minus_button, program_button, set_alarm_button, turn_off_alarm_button,
    output debounced_plus_button, debounced_minus_button, debounced_program_button, debounced_set_alarm_button, debounced_turn_off_alarm_button
);

    SingleDebouncer debounce_plus_button(clk, rst_n, plus_button, debounced_plus_button);
    SingleDebouncer debounce_minus_button(clk, rst_n, minus_button, debounced_minus_button);
    SingleDebouncer debounce_program_button(clk, rst_n, plus_button, debounced_program_button);
    SingleDebouncer debounce_set_alarm_button(clk, rst_n, set_alarm_button, debounced_set_alarm_button);
    SingleDebouncer debounce_turn_off_alarm_button(clk, rst_n, turn_off_alarm_button, debounced_turn_off_alarm_button);

endmodule
