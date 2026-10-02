`timescale 1ns/1ps

module tb_wave;

reg clk;
reg reset;
reg [31:0] frequency_step;
reg [1:0] wave_type;
wire [7:0] wave_out;

wave_generator_core #(
    .USE_CORDIC(1)
) uut (
    .clk(clk),
    .reset(reset),
    .frequency_step(frequency_step),
    .wave_type(wave_type),
    .wave_out(wave_out)
);

// Clock 50MHz
initial begin
    clk = 0;
    forever #10 clk = ~clk;
end

initial begin
    reset = 1;
    wave_type = 2'b00;

    frequency_step = 32'd85899345;

    #50 reset = 0;

    $display("Testing Square Wave...");
    wave_type = 2'b00;
    #2000;

    $display("Testing Triangle Wave...");
    wave_type = 2'b01;
    #2000;

    $display("Testing Sine Wave...");
    wave_type = 2'b10;
    #2000;

    $display("Testing Cosine Wave...");
    wave_type = 2'b11;
    #2000;

    $display("Simulation Finished.");
    $stop;
end
endmodule
