`timescale 1ns / 1ps
module alu (
    input  [3:0] A,
    input  [3:0] B,
    input  [2:0] OP,

    output reg [3:0] result,
    output reg       carry,
    output reg       zero,
    output reg       overflow
);

reg [4:0] temp;

always @(*) begin

    // Default values
    result   = 4'b0000;
    carry    = 1'b0;
    zero     = 1'b0;
    overflow = 1'b0;
    temp     = 5'b00000;

    case (OP)

        // ADD
        3'b000: begin
            temp   = {1'b0, A} + {1'b0, B};
            result = temp[3:0];
            carry  = temp[4];

            // Signed overflow
            overflow = (~(A[3] ^ B[3])) & (result[3] ^ A[3]);
        end

        // SUB
        3'b001: begin
            result = A - B;

            // Borrow indication
            carry = (A < B);

            // Signed overflow
            overflow = (A[3] ^ B[3]) & (result[3] ^ A[3]);
        end

        // AND
        3'b010: begin
            result = A & B;
        end

        // OR
        3'b011: begin
            result = A | B;
        end

        // XOR
        3'b100: begin
            result = A ^ B;
        end

        // NOT
        3'b101: begin
            result = ~A;
        end

        // SHIFT LEFT
        3'b110: begin
            result = A << 1;
            carry  = A[3];
        end

        // SHIFT RIGHT
        3'b111: begin
            result = A >> 1;
            carry  = A[0];
        end

        default: begin
            result = 4'b0000;
        end

    endcase

    // Zero flag
    if (result == 4'b0000)
        zero = 1'b1;
    else
        zero = 1'b0;

end

endmodule