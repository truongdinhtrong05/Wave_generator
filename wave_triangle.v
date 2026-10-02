module wave_triangle(
    input  [31:0] phase_acc,
    output [7:0]  wave_out
);
assign wave_out = (phase_acc[31]) ? ~phase_acc[30:23] : phase_acc[30:23];
endmodule
