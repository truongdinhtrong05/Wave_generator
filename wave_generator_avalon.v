module wave_generator_avalon #(
    parameter USE_CORDIC = 0
)(
    input iClk,
    input iReset_n,
    input iChipSelect_n,
    input iWrite_n,
    input iRead_n,
    input [1:0] iAddress,
    input [31:0] iData,
    output reg [31:0] oReadData,
    output [7:0] oData
);

reg [31:0] reg_frequency_step;
reg [1:0] reg_wave_type;

always @(posedge iClk or negedge iReset_n) begin
    if (!iReset_n) begin
        reg_frequency_step <= 32'd10000;
        reg_wave_type <= 2'd0;
    end else if (!iChipSelect_n && !iWrite_n) begin
        case (iAddress)
            2'b00: reg_frequency_step <= iData;
            2'b01: reg_wave_type <= iData[1:0];
        endcase
    end
end

always @(*) begin
    if (!iChipSelect_n && !iRead_n) begin
        case (iAddress)
            2'b00: oReadData = reg_frequency_step;
            2'b01: oReadData = {30'd0, reg_wave_type};
            default: oReadData = 32'd0;
        endcase
    end else begin
        oReadData = 32'd0;
    end
end

wave_generator_core #(
    .USE_CORDIC(USE_CORDIC)
) u_wave_core(
    .clk(iClk),
    .reset(~iReset_n),
    .frequency_step(reg_frequency_step),
    .wave_type(reg_wave_type),
    .wave_out(oData)
);
endmodule
