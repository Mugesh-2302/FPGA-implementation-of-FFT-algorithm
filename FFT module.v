module fft_test (
    input clk,                      // Clock signal
    input reset,                    // Reset signal
    input signed [3:0] x0_real,     // Input real part of x0
    input signed [3:0] x0_imag,
    input signed [3:0] x1_real,
    input signed [3:0] x1_imag,
    input signed [3:0] x2_real,
    input signed [3:0] x2_imag,
    input signed [3:0] x3_real,
    input signed [3:0] x3_imag,
    output reg signed [3:0] y0_real,
    output reg signed [3:0] y0_imag,
    output reg signed [3:0] y1_real,
    output reg signed [3:0] y1_imag,
    output reg signed [3:0] y2_real,
    output reg signed [3:0] y2_imag,
    output reg signed [3:0] y3_real,
    output reg signed [3:0] y3_imag
);

    // Twiddle factors (4-bit signed fixed-point)
    wire signed [3:0] w0_real = 4'd7;  // W0 = 1
    wire signed [3:0] w0_imag = 4'd0;
    wire signed [3:0] w1_real = 4'd0;  // W1 = -j
    wire signed [3:0] w1_imag = -4'd7;
    wire signed [3:0] w2_real = -4'd7; // W2 = -1
    wire signed [3:0] w2_imag = 4'd0;
    wire signed [3:0] w3_real = 4'd0;  // W3 = j
    wire signed [3:0] w3_imag = 4'd7;

    // Butterfly intermediate signals
    reg signed [3:0] stage1_0_real, stage1_0_imag;
    reg signed [3:0] stage1_1_real, stage1_1_imag;
    reg signed [3:0] stage1_2_real, stage1_2_imag;
    reg signed [3:0] stage1_3_real, stage1_3_imag;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stage1_0_real <= 0;
            stage1_0_imag <= 0;
            stage1_1_real <= 0;
            stage1_1_imag <= 0;
            stage1_2_real <= 0;
            stage1_2_imag <= 0;
            stage1_3_real <= 0;
            stage1_3_imag <= 0;
        end else begin
            // Stage 1 Butterfly operation
            stage1_0_real <= x0_real + x2_real;
            stage1_0_imag <= x0_imag + x2_imag;
            stage1_1_real <= x0_real - x2_real;
            stage1_1_imag <= x0_imag - x2_imag;
            stage1_2_real <= x1_real + x3_real;
            stage1_2_imag <= x1_imag + x3_imag;
            stage1_3_real <= x1_real - x3_real;
            stage1_3_imag <= x1_imag - x3_imag;
        end
    end

    // Stage 2 Butterfly operation with twiddle factors
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            y0_real <= 0;
            y0_imag <= 0;
            y1_real <= 0;
            y1_imag <= 0;
            y2_real <= 0;
            y2_imag <= 0;
            y3_real <= 0;
            y3_imag <= 0;
        end else begin
            // Final FFT output
            y0_real <= stage1_0_real + stage1_2_real;
            y0_imag <= stage1_0_imag + stage1_2_imag;

            y1_real <= stage1_1_real + stage1_3_imag;
            y1_imag <= stage1_1_imag - stage1_3_real;

            y2_real <= stage1_0_real - stage1_2_real;
            y2_imag <= stage1_0_imag - stage1_2_imag;

            y3_real <= stage1_1_real - stage1_3_imag;
            y3_imag <= stage1_1_imag + stage1_3_real;
        end
    end

endmodule
