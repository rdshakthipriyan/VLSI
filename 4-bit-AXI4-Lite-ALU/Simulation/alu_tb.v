`timescale 1ns / 1ps

module alu_tb;

    reg [3:0] A;
    reg [3:0] B;
    reg [2:0] OP;

    wire [3:0] result;
    wire       carry;
    wire       zero;
    wire       overflow;

    // Instantiate ALU
    alu uut (
        .A(A),
        .B(B),
        .OP(OP),
        .result(result),
        .carry(carry),
        .zero(zero),
        .overflow(overflow)
    );


    // ==========================================
    // TEST TASK
    // ==========================================

    task test_operation;

        input [3:0] test_A;
        input [3:0] test_B;
        input [2:0] test_OP;

        input [3:0] expected_result;
        input        expected_carry;
        input        expected_zero;
        input        expected_overflow;

        input [127:0] operation_name;

        begin

            A  = test_A;
            B  = test_B;
            OP = test_OP;

            #10;

            if ((result === expected_result) &&
                (carry === expected_carry) &&
                (zero === expected_zero) &&
                (overflow === expected_overflow)) begin

                $display(
                    "%s : PASS | A=%d B=%d Result=%d Carry=%b Zero=%b Overflow=%b",
                    operation_name,
                    A,
                    B,
                    result,
                    carry,
                    zero,
                    overflow
                );

            end
            else begin

                $display(
                    "%s : FAIL | A=%d B=%d | Expected: Result=%d Carry=%b Zero=%b Overflow=%b | Got: Result=%d Carry=%b Zero=%b Overflow=%b",
                    operation_name,
                    A,
                    B,
                    expected_result,
                    expected_carry,
                    expected_zero,
                    expected_overflow,
                    result,
                    carry,
                    zero,
                    overflow
                );

            end

        end

    endtask


    // ==========================================
    // TEST CASES
    // ==========================================

    initial begin

        $display("==============================================");
        $display("              ALU TEST START");
        $display("==============================================");


        // --------------------------------------
        // BASIC OPERATIONS
        // --------------------------------------

        test_operation(
            4'd5, 4'd3, 3'b000,
            4'd8, 1'b0, 1'b0, 1'b1,
            "ADD"
        );

        test_operation(
            4'd5, 4'd3, 3'b001,
            4'd2, 1'b0, 1'b0, 1'b0,
            "SUB"
        );

        test_operation(
            4'd5, 4'd3, 3'b010,
            4'd1, 1'b0, 1'b0, 1'b0,
            "AND"
        );

        test_operation(
            4'd5, 4'd3, 3'b011,
            4'd7, 1'b0, 1'b0, 1'b0,
            "OR"
        );

        test_operation(
            4'd5, 4'd3, 3'b100,
            4'd6, 1'b0, 1'b0, 1'b0,
            "XOR"
        );

        test_operation(
            4'd5, 4'd0, 3'b101,
            4'd10, 1'b0, 1'b0, 1'b0,
            "NOT"
        );

        test_operation(
            4'd5, 4'd0, 3'b110,
            4'd10, 1'b0, 1'b0, 1'b0,
            "SHIFT LEFT"
        );

        test_operation(
            4'd5, 4'd0, 3'b111,
            4'd2, 1'b1, 1'b0, 1'b0,
            "SHIFT RIGHT"
        );


        // --------------------------------------
        // CARRY TEST
        // --------------------------------------

        test_operation(
            4'd15, 4'd1, 3'b000,
            4'd0, 1'b1, 1'b1, 1'b0,
            "ADD CARRY"
        );

        test_operation(
            4'd15, 4'd15, 3'b000,
            4'd14, 1'b1, 1'b0, 1'b0,
            "ADD MAX"
        );


        // --------------------------------------
        // ZERO TEST
        // --------------------------------------

        test_operation(
            4'd5, 4'd5, 3'b001,
            4'd0, 1'b0, 1'b1, 1'b0,
            "SUB ZERO"
        );


        // --------------------------------------
        // SUBTRACTION BORROW
        // --------------------------------------

        test_operation(
            4'd0, 4'd1, 3'b001,
            4'd15, 1'b1, 1'b0, 1'b0,
            "SUB BORROW"
        );


        // --------------------------------------
        // SIGNED ADDITION OVERFLOW
        // --------------------------------------

        // +7 + +1 = +8
        // +8 cannot be represented in 4-bit signed
        // Result becomes 1000 (-8)
        test_operation(
            4'd7, 4'd1, 3'b000,
            4'd8, 1'b0, 1'b0, 1'b1,
            "ADD OVERFLOW"
        );


        // --------------------------------------
        // SECOND ADD OVERFLOW
        // --------------------------------------

        // +5 + +3 = +8
        test_operation(
            4'd5, 4'd3, 3'b000,
            4'd8, 1'b0, 1'b0, 1'b1,
            "ADD 5+3 OVERFLOW"
        );


        // --------------------------------------
        // SIGNED SUBTRACTION OVERFLOW
        // --------------------------------------

        // -8 - 1 = -9
        // -9 cannot be represented in 4-bit signed
        // Result becomes 0111 (+7)
        test_operation(
            4'b1000, 4'd1, 3'b001,
            4'd7, 1'b0, 1'b0, 1'b1,
            "SUB OVERFLOW"
        );


        $display("==============================================");
        $display("              ALU TEST COMPLETE");
        $display("==============================================");

        $finish;

    end

endmodule