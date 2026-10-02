module wave_generator(
    input CLOCK_50,
    input [0:0] KEY,
    output [7:0] GPIO
);

system Nios_system (
    .clk_clk (CLOCK_50),
    .reset_reset_n (KEY[0]),
    .wave_gen_avalon_0_conduit_end_export (GPIO)
);
endmodule
