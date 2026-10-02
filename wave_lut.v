module wave_lut(
    input clk,
    input [7:0] phase_acc,
    output reg [7:0] sin_out,
    output reg [7:0] cos_out
);
(* ramstyle = "block" *) reg [7:0] sin_rom [0:255];

initial begin
    $readmemh("sine.txt", sin_rom);
end

reg [7:0] phase_index_sin, phase_index_cos;

always @(posedge clk) begin
    phase_index_sin <= phase_acc;
    phase_index_cos <= phase_acc + 8'd64;
end

always @(posedge clk) begin
    sin_out <= sin_rom[phase_index_sin];
    cos_out <= sin_rom[phase_index_cos];
end
endmodule
