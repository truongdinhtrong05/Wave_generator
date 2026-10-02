module wave_cordic(
    input clk,
    input [31:0] phase_acc,
    output reg [7:0] sin_out,
    output reg [7:0] cos_out
);

wire [1:0] quad = phase_acc[31:30];

wire [13:0] base_angle = phase_acc[29:16];
wire [13:0] cordic_angle = (quad == 2'b01 || quad == 2'b11) ? ~base_angle : base_angle;
wire signed [15:0] target_angle = {2'b00, cordic_angle};

reg signed [15:0] x [0:8], y [0:8], z [0:8];
reg [1:0] quad_delay [0:8];

always @(posedge clk) begin
    // Tầng 0
    x[0] <= 16'd9949;
    y[0] <= 16'd0;
    z[0] <= target_angle;
    quad_delay[0] <= quad;

    // Tầng 1
    quad_delay[1] <= quad_delay[0];
    if (z[0] >= 0) begin
        x[1] <= x[0] - (y[0] >>> 0);
        y[1] <= y[0] + (x[0] >>> 0);
        z[1] <= z[0] - 16'd8192;
    end else begin
        x[1] <= x[0] + (y[0] >>> 0);
        y[1] <= y[0] - (x[0] >>> 0);
        z[1] <= z[0] + 16'd8192;
    end

    // Tầng 2
    quad_delay[2] <= quad_delay[1];
    if (z[1] >= 0) begin
        x[2] <= x[1] - (y[1] >>> 1);
        y[2] <= y[1] + (x[1] >>> 1);
        z[2] <= z[1] - 16'd4836;
    end else begin
        x[2] <= x[1] + (y[1] >>> 1);
        y[2] <= y[1] - (x[1] >>> 1);
        z[2] <= z[1] + 16'd4836;
    end

    // Tầng 3
    quad_delay[3] <= quad_delay[2];
    if (z[2] >= 0) begin
        x[3] <= x[2] - (y[2] >>> 2);
        y[3] <= y[2] + (x[2] >>> 2);
        z[3] <= z[2] - 16'd2555;
    end else begin
        x[3] <= x[2] + (y[2] >>> 2);
        y[3] <= y[2] - (x[2] >>> 2);
        z[3] <= z[2] + 16'd2555;
    end

    // Tầng 4
    quad_delay[4] <= quad_delay[3];
    if (z[3] >= 0) begin
        x[4] <= x[3] - (y[3] >>> 3);
        y[4] <= y[3] + (x[3] >>> 3);
        z[4] <= z[3] - 16'd1297;
    end else begin
        x[4] <= x[3] + (y[3] >>> 3);
        y[4] <= y[3] - (x[3] >>> 3);
        z[4] <= z[3] + 16'd1297;
    end

    // Tầng 5
    quad_delay[5] <= quad_delay[4];
    if (z[4] >= 0) begin
        x[5] <= x[4] - (y[4] >>> 4);
        y[5] <= y[4] + (x[4] >>> 4);
        z[5] <= z[4] - 16'd651;
    end else begin
        x[5] <= x[4] + (y[4] >>> 4);
        y[5] <= y[4] - (x[4] >>> 4);
        z[5] <= z[4] + 16'd651;
    end

    // Tầng 6
    quad_delay[6] <= quad_delay[5];
    if (z[5] >= 0) begin
        x[6] <= x[5] - (y[5] >>> 5);
        y[6] <= y[5] + (x[5] >>> 5);
        z[6] <= z[5] - 16'd326;
    end else begin
        x[6] <= x[5] + (y[5] >>> 5);
        y[6] <= y[5] - (x[5] >>> 5);
        z[6] <= z[5] + 16'd326;
    end

    // Tầng 7
    quad_delay[7] <= quad_delay[6];
    if (z[6] >= 0) begin
        x[7] <= x[6] - (y[6] >>> 6);
        y[7] <= y[6] + (x[6] >>> 6);
        z[7] <= z[6] - 16'd163;
    end else begin
        x[7] <= x[6] + (y[6] >>> 6);
        y[7] <= y[6] - (x[6] >>> 6);
        z[7] <= z[6] + 16'd163;
    end

    // Tầng 8
    quad_delay[8] <= quad_delay[7];
    if (z[7] >= 0) begin
        x[8] <= x[7] - (y[7] >>> 7);
        y[8] <= y[7] + (x[7] >>> 7);
        z[8] <= z[7] - 16'd81;
    end else begin
        x[8] <= x[7] + (y[7] >>> 7);
        y[8] <= y[7] - (x[7] >>> 7);
        z[8] <= z[7] + 16'd81;
    end
end

// Đổi dấu theo góc phần tư
reg signed [16:0] final_sin, final_cos;
always @(posedge clk) begin
    case (quad_delay[8])
        2'b00: begin
            final_sin <= y[8];
            final_cos <= x[8];
        end
        2'b01: begin
            final_sin <= y[8];
            final_cos <= -x[8];
        end
        2'b10: begin
            final_sin <= -y[8];
            final_cos <= -x[8];
        end
        2'b11: begin
            final_sin <= -y[8];
            final_cos <= x[8];
        end
    endcase

    // Đưa đầu ra về mức 0-255
    sin_out <= (final_sin[14:7]) + 8'd128;
    cos_out <= (final_cos[14:7]) + 8'd128;
end
endmodule
