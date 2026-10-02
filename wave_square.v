module wave_square(
    input  [31:0] phase_acc,
    output [7:0]  wave_out
);
assign wave_out = (phase_acc[31]) ? 8'hFF : 8'h00;
endmodule
