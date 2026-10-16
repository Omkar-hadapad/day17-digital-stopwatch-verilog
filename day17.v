`timescale 1ns/1ps

//======================================================================
// DAY 17 - DIGITAL STOPWATCH / TIMER
//
// DIGITS : 2
// RANGE  : 00 to 99
//
// HIERARCHY:
//
// BASIC GATES
//     ↓
// HALF ADDER
//     ↓
// FULL ADDER
//     ↓
// 4-BIT INCREMENTER
//     ↓
// BCD DIGIT COUNTER
//     ↓
// START/STOP CONTROL
//     ↓
// STRUCTURAL STOPWATCH
//     ↓
// RTL STOPWATCH
//     ↓
// TOP MODULE
//======================================================================


//======================================================================
// LEVEL 1 : BASIC GATES
//======================================================================

module not_gate(
    input A,
    output Y
);
    assign Y = ~A;
endmodule


module and_gate(
    input A,
    input B,
    output Y
);
    assign Y = A & B;
endmodule


module or_gate(
    input A,
    input B,
    output Y
);
    assign Y = A | B;
endmodule


module xor_gate(
    input A,
    input B,
    output Y
);
    assign Y = A ^ B;
endmodule


module nand_gate(
    input A,
    input B,
    output Y
);
    assign Y = ~(A & B);
endmodule


module nor_gate(
    input A,
    input B,
    output Y
);
    assign Y = ~(A | B);
endmodule


//======================================================================
// LEVEL 2 : HALF ADDER
//======================================================================

module half_adder(
    input A,
    input B,
    output Sum,
    output Carry
);

    xor_gate XOR1(
        .A(A),
        .B(B),
        .Y(Sum)
    );

    and_gate AND1(
        .A(A),
        .B(B),
        .Y(Carry)
    );

endmodule


//======================================================================
// LEVEL 3 : FULL ADDER
//======================================================================

module full_adder(
    input A,
    input B,
    input Cin,
    output Sum,
    output Cout
);

    wire S1;
    wire C1;
    wire C2;

    half_adder HA1(
        .A(A),
        .B(B),
        .Sum(S1),
        .Carry(C1)
    );

    half_adder HA2(
        .A(S1),
        .B(Cin),
        .Sum(Sum),
        .Carry(C2)
    );

    or_gate OR1(
        .A(C1),
        .B(C2),
        .Y(Cout)
    );

endmodule


//======================================================================
// LEVEL 4 : 4-BIT INCREMENTER
//======================================================================

module incrementer_4bit(
    input [3:0] A,
    output [3:0] Y
);

    wire C1;
    wire C2;
    wire C3;
    wire C4;

    full_adder FA0(
        .A(A[0]),
        .B(1'b0),
        .Cin(1'b1),
        .Sum(Y[0]),
        .Cout(C1)
    );

    full_adder FA1(
        .A(A[1]),
        .B(1'b0),
        .Cin(C1),
        .Sum(Y[1]),
        .Cout(C2)
    );

    full_adder FA2(
        .A(A[2]),
        .B(1'b0),
        .Cin(C2),
        .Sum(Y[2]),
        .Cout(C3)
    );

    full_adder FA3(
        .A(A[3]),
        .B(1'b0),
        .Cin(C3),
        .Sum(Y[3]),
        .Cout(C4)
    );

endmodule


//======================================================================
// LEVEL 5 : BCD DIGIT NEXT-STATE
//
// Valid BCD states:
// 0 1 2 3 4 5 6 7 8 9
//
// 9 -> 0 with carry
//======================================================================

module bcd_digit_next(
    input [3:0] digit,
    input enable,

    output [3:0] next_digit,
    output carry
);

    wire [3:0] incremented;

    incrementer_4bit INC(
        .A(digit),
        .Y(incremented)
    );

    assign carry =
        enable && (digit == 4'd9);

    assign next_digit =
        !enable       ? digit :
        (digit == 4'd9) ? 4'd0 :
                          incremented;

endmodule


//======================================================================
// LEVEL 6 : START/STOP CONTROL
//
// start = 1 -> running
// stop  = 1 -> stopped
//
// If both are 0, previous state is held.
// Start has priority when both are asserted.
//======================================================================

module stopwatch_control(
    input clk,
    input reset,
    input start,
    input stop,

    output reg running
);

    always @(posedge clk)
    begin

        if(reset)
            running <= 1'b0;

        else if(start)
            running <= 1'b1;

        else if(stop)
            running <= 1'b0;

    end

endmodule


//======================================================================
// LEVEL 7 : BCD REGISTER
//======================================================================

module bcd_digit_register(
    input clk,
    input reset,
    input enable,

    input [3:0] next_digit,

    output reg [3:0] digit
);

    always @(posedge clk)
    begin

        if(reset)
            digit <= 4'd0;

        else if(enable)
            digit <= next_digit;

    end

endmodule


//======================================================================
// LEVEL 8 : STRUCTURAL STOPWATCH
//======================================================================

module stopwatch_structural(

    input clk,
    input reset,
    input start,
    input stop,

    output [3:0] tens,
    output [3:0] ones,
    output running
);

    wire [3:0] ones_next;
    wire [3:0] tens_next;

    wire ones_carry;


    // ---------------------------------------------------------------
    // START / STOP
    // ---------------------------------------------------------------

    stopwatch_control CONTROL(
        .clk(clk),
        .reset(reset),
        .start(start),
        .stop(stop),
        .running(running)
    );


    // ---------------------------------------------------------------
    // ONES DIGIT
    // ---------------------------------------------------------------

    bcd_digit_next ONES_NEXT(
        .digit(ones),
        .enable(running),
        .next_digit(ones_next),
        .carry(ones_carry)
    );


    bcd_digit_register ONES_REG(
        .clk(clk),
        .reset(reset),
        .enable(running),
        .next_digit(ones_next),
        .digit(ones)
    );


    // ---------------------------------------------------------------
    // TENS DIGIT
    // ---------------------------------------------------------------

    bcd_digit_next TENS_NEXT(
        .digit(tens),
        .enable(ones_carry),
        .next_digit(tens_next),
        .carry()
    );


    bcd_digit_register TENS_REG(
        .clk(clk),
        .reset(reset),
        .enable(ones_carry),
        .next_digit(tens_next),
        .digit(tens)
    );

endmodule


//======================================================================
// LEVEL 9 : RTL STOPWATCH
//======================================================================

module stopwatch_rtl(

    input clk,
    input reset,
    input start,
    input stop,

    output reg [3:0] tens,
    output reg [3:0] ones,
    output reg running
);

    always @(posedge clk)
    begin

        if(reset)
        begin
            tens    <= 4'd0;
            ones    <= 4'd0;
            running <= 1'b0;
        end

        else
        begin

            // -------------------------------------------------------
            // START / STOP CONTROL
            // -------------------------------------------------------

            if(start)
                running <= 1'b1;

            else if(stop)
                running <= 1'b0;


            // -------------------------------------------------------
            // STOPWATCH COUNT
            // -------------------------------------------------------

            if(running)
            begin

                if(ones == 4'd9)
                begin
                    ones <= 4'd0;

                    if(tens == 4'd9)
                        tens <= 4'd0;

                    else
                        tens <= tens + 4'd1;
                end

                else
                begin
                    ones <= ones + 4'd1;
                end

            end

        end

    end

endmodule


//======================================================================
// LEVEL 10 : TOP MODULE
//======================================================================

module stopwatch_top(

    input clk,
    input reset,
    input start,
    input stop,

    output [3:0] tens,
    output [3:0] ones,
    output running
);

    stopwatch_structural DUT(
        .clk(clk),
        .reset(reset),
        .start(start),
        .stop(stop),

        .tens(tens),
        .ones(ones),
        .running(running)
    );

endmodule