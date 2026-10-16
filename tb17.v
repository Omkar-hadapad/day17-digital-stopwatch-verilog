`timescale 1ns/1ps

//======================================================================
// DAY 17 TESTBENCH
// DIGITAL STOPWATCH / TIMER
//
// SELF-CHECKING VERIFICATION
//======================================================================

module day17_tb;

    reg clk;
    reg reset;
    reg start;
    reg stop;

    integer pass_count;
    integer fail_count;
    integer i;


    //==================================================================
    // CLOCK
    //==================================================================

    initial
    begin
        clk = 1'b0;

        forever
            #5 clk = ~clk;
    end


    //==================================================================
    // BASIC GATES
    //==================================================================

    reg A;
    reg B;

    wire not_y;
    wire and_y;
    wire or_y;
    wire xor_y;
    wire nand_y;
    wire nor_y;

    not_gate NOT1(.A(A), .Y(not_y));
    and_gate AND1(.A(A), .B(B), .Y(and_y));
    or_gate OR1(.A(A), .B(B), .Y(or_y));
    xor_gate XOR1(.A(A), .B(B), .Y(xor_y));
    nand_gate NAND1(.A(A), .B(B), .Y(nand_y));
    nor_gate NOR1(.A(A), .B(B), .Y(nor_y));


    //==================================================================
    // HALF ADDER
    //==================================================================

    wire ha_sum;
    wire ha_carry;

    half_adder HA(
        .A(A),
        .B(B),
        .Sum(ha_sum),
        .Carry(ha_carry)
    );


    //==================================================================
    // FULL ADDER
    //==================================================================

    reg Cin;

    wire fa_sum;
    wire fa_carry;

    full_adder FA(
        .A(A),
        .B(B),
        .Cin(Cin),
        .Sum(fa_sum),
        .Cout(fa_carry)
    );


    //==================================================================
    // INCREMENTER
    //==================================================================

    reg [3:0] inc_A;
    wire [3:0] inc_Y;

    incrementer_4bit INC(
        .A(inc_A),
        .Y(inc_Y)
    );


    //==================================================================
    // BCD NEXT-STATE
    //==================================================================

    reg [3:0] bcd_digit;
    reg bcd_enable;

    wire [3:0] bcd_next;
    wire bcd_carry;

    bcd_digit_next BCD_NEXT(
        .digit(bcd_digit),
        .enable(bcd_enable),
        .next_digit(bcd_next),
        .carry(bcd_carry)
    );


    //==================================================================
    // CONTROL
    //==================================================================

    wire control_running;

    stopwatch_control CONTROL(
        .clk(clk),
        .reset(reset),
        .start(start),
        .stop(stop),
        .running(control_running)
    );


    //==================================================================
    // STRUCTURAL STOPWATCH
    //==================================================================

    wire [3:0] s_tens;
    wire [3:0] s_ones;
    wire s_running;

    stopwatch_structural STRUCTURAL(
        .clk(clk),
        .reset(reset),
        .start(start),
        .stop(stop),

        .tens(s_tens),
        .ones(s_ones),
        .running(s_running)
    );


    //==================================================================
    // RTL STOPWATCH
    //==================================================================

    wire [3:0] r_tens;
    wire [3:0] r_ones;
    wire r_running;

    stopwatch_rtl RTL(
        .clk(clk),
        .reset(reset),
        .start(start),
        .stop(stop),

        .tens(r_tens),
        .ones(r_ones),
        .running(r_running)
    );


    //==================================================================
    // CHECK 1-BIT
    //==================================================================

    task check_1bit;

        input [127:0] name;
        input expected;
        input actual;

        begin

            if(expected === actual)
            begin
                pass_count = pass_count + 1;

                $display(
                    "PASS : %s | EXP=%b ACT=%b",
                    name,
                    expected,
                    actual
                );
            end

            else
            begin
                fail_count = fail_count + 1;

                $display(
                    "FAIL : %s | EXP=%b ACT=%b",
                    name,
                    expected,
                    actual
                );
            end

        end

    endtask


    //==================================================================
    // CHECK 4-BIT
    //==================================================================

    task check_4bit;

        input [127:0] name;
        input [3:0] expected;
        input [3:0] actual;

        begin

            if(expected === actual)
            begin
                pass_count = pass_count + 1;

                $display(
                    "PASS : %s | EXP=%h ACT=%h",
                    name,
                    expected,
                    actual
                );
            end

            else
            begin
                fail_count = fail_count + 1;

                $display(
                    "FAIL : %s | EXP=%h ACT=%h",
                    name,
                    expected,
                    actual
                );
            end

        end

    endtask


    //==================================================================
    // MAIN TEST
    //==================================================================

    initial
    begin

        pass_count = 0;
        fail_count = 0;

        A = 0;
        B = 0;
        Cin = 0;

        inc_A = 0;

        bcd_digit = 0;
        bcd_enable = 0;

        reset = 1;
        start = 0;
        stop = 0;


        //==============================================================
        // VCD
        //==============================================================

        $dumpfile("day17.vcd");
        $dumpvars(0, day17_tb);


        //==============================================================
        // TEST 1 : BASIC GATES
        //==============================================================

        $display("\n==============================================");
        $display("TEST 1 : BASIC GATES");
        $display("==============================================");

        for(i = 0; i < 4; i = i + 1)
        begin

            A = i[1];
            B = i[0];

            #1;

            check_1bit("NOT", ~A, not_y);
            check_1bit("AND", A & B, and_y);
            check_1bit("OR", A | B, or_y);
            check_1bit("XOR", A ^ B, xor_y);
            check_1bit("NAND", ~(A & B), nand_y);
            check_1bit("NOR", ~(A | B), nor_y);

        end


        //==============================================================
        // TEST 2 : HALF ADDER
        //==============================================================

        $display("\n==============================================");
        $display("TEST 2 : HALF ADDER");
        $display("==============================================");

        for(i = 0; i < 4; i = i + 1)
        begin

            A = i[1];
            B = i[0];

            #1;

            check_1bit("HA SUM", A ^ B, ha_sum);
            check_1bit("HA CARRY", A & B, ha_carry);

        end


        //==============================================================
        // TEST 3 : FULL ADDER
        //==============================================================

        $display("\n==============================================");
        $display("TEST 3 : FULL ADDER");
        $display("==============================================");

        for(i = 0; i < 8; i = i + 1)
        begin

            A = i[2];
            B = i[1];
            Cin = i[0];

            #1;

            check_1bit(
                "FA SUM",
                A ^ B ^ Cin,
                fa_sum
            );

            check_1bit(
                "FA CARRY",
                (A&B)|(A&Cin)|(B&Cin),
                fa_carry
            );

        end


        //==============================================================
        // TEST 4 : INCREMENTER
        //==============================================================

        $display("\n==============================================");
        $display("TEST 4 : 4-BIT INCREMENTER");
        $display("==============================================");

        for(i = 0; i < 16; i = i + 1)
        begin

            inc_A = i[3:0];

            #1;

            check_4bit(
                "INCREMENTER",
                i + 1,
                inc_Y
            );

        end


        //==============================================================
        // TEST 5 : BCD DIGIT LOGIC
        //==============================================================

        $display("\n==============================================");
        $display("TEST 5 : BCD DIGIT NEXT-STATE");
        $display("==============================================");

        bcd_enable = 1;

        for(i = 0; i < 10; i = i + 1)
        begin

            bcd_digit = i;

            #1;

            if(i == 9)
            begin

                check_4bit(
                    "BCD 9->0",
                    4'd0,
                    bcd_next
                );

                check_1bit(
                    "BCD CARRY",
                    1'b1,
                    bcd_carry
                );

            end

            else
            begin

                check_4bit(
                    "BCD INCREMENT",
                    i + 1,
                    bcd_next
                );

                check_1bit(
                    "BCD NO CARRY",
                    1'b0,
                    bcd_carry
                );

            end

        end

        bcd_enable = 0;
        bcd_digit = 4'd5;

        #1;

        check_4bit(
            "BCD HOLD",
            4'd5,
            bcd_next
        );


        //==============================================================
        // TEST 6 : RESET
        //==============================================================

        $display("\n==============================================");
        $display("TEST 6 : RESET");
        $display("==============================================");

        reset = 1;

        @(posedge clk);
        #1;

        check_4bit(
            "STRUCTURAL TENS RESET",
            4'd0,
            s_tens
        );

        check_4bit(
            "STRUCTURAL ONES RESET",
            4'd0,
            s_ones
        );

        check_1bit(
            "STRUCTURAL RUN RESET",
            1'b0,
            s_running
        );

        check_4bit(
            "RTL TENS RESET",
            4'd0,
            r_tens
        );

        check_4bit(
            "RTL ONES RESET",
            4'd0,
            r_ones
        );

        check_1bit(
            "RTL RUN RESET",
            1'b0,
            r_running
        );


        //==============================================================
        // TEST 7 : START
        //==============================================================

        $display("\n==============================================");
        $display("TEST 7 : START");
        $display("==============================================");

        reset = 0;
        start = 1;

        @(posedge clk);
        #1;

        start = 0;

        check_1bit(
            "START STRUCTURAL",
            1'b1,
            s_running
        );

        check_1bit(
            "START RTL",
            1'b1,
            r_running
        );


        //==============================================================
        // TEST 8 : COUNT 00 -> 09
        //==============================================================

        $display("\n==============================================");
        $display("TEST 8 : ONES COUNT");
        $display("==============================================");

        for(i = 1; i <= 9; i = i + 1)
        begin

            @(posedge clk);
            #1;

            check_4bit(
                "ONES STRUCTURAL",
                i,
                s_ones
            );

            check_4bit(
                "ONES RTL",
                i,
                r_ones
            );

            check_1bit(
                "STRUCTURAL VS RTL RUN",
                s_running,
                r_running
            );

        end


        //==============================================================
        // TEST 9 : 09 -> 10
        //==============================================================

        $display("\n==============================================");
        $display("TEST 9 : 09 -> 10 ROLLOVER");
        $display("==============================================");

        @(posedge clk);
        #1;

        check_4bit(
            "TENS 09->10",
            4'd1,
            s_tens
        );

        check_4bit(
            "ONES 09->10",
            4'd0,
            s_ones
        );


        //==============================================================
        // TEST 10 : COUNT TO 99
        //==============================================================

        $display("\n==============================================");
        $display("TEST 10 : COUNT TO 99");
        $display("==============================================");

        // Current state = 10.
        // Count 89 more cycles to reach 99.

        for(i = 0; i < 89; i = i + 1)
        begin

            @(posedge clk);
            #1;

            check_4bit(
                "STRUCTURAL TENS",
                r_tens,
                s_tens
            );

            check_4bit(
                "STRUCTURAL ONES",
                r_ones,
                s_ones
            );

        end


        check_4bit(
            "99 TENS",
            4'd9,
            s_tens
        );

        check_4bit(
            "99 ONES",
            4'd9,
            s_ones
        );


        //==============================================================
        // TEST 11 : 99 -> 00
        //==============================================================

        $display("\n==============================================");
        $display("TEST 11 : 99 -> 00");
        $display("==============================================");

        @(posedge clk);
        #1;

        check_4bit(
            "99->00 TENS",
            4'd0,
            s_tens
        );

        check_4bit(
            "99->00 ONES",
            4'd0,
            s_ones
        );

        check_4bit(
            "RTL 99->00 TENS",
            4'd0,
            r_tens
        );

        check_4bit(
            "RTL 99->00 ONES",
            4'd0,
            r_ones
        );


        //==============================================================
        // TEST 12 : STOP / HOLD
        //==============================================================

        $display("\n==============================================");
        $display("TEST 12 : STOP / HOLD");
        $display("==============================================");

        stop = 1;

        @(posedge clk);
        #1;

        stop = 0;

        check_1bit(
            "STOP STRUCTURAL",
            1'b0,
            s_running
        );

        check_1bit(
            "STOP RTL",
            1'b0,
            r_running
        );

        // Store current value
        bcd_digit = s_ones;


        repeat(5)
        begin

            @(posedge clk);
            #1;

            check_4bit(
                "STOP HOLD ONES",
                bcd_digit,
                s_ones
            );

        end


        //==============================================================
        // TEST 13 : RESTART
        //==============================================================

        $display("\n==============================================");
        $display("TEST 13 : RESTART");
        $display("==============================================");

        start = 1;

        @(posedge clk);
        #1;

        start = 0;

        check_1bit(
            "RESTART",
            1'b1,
            s_running
        );

        @(posedge clk);
        #1;

        check_4bit(
            "RESTART COUNT",
            bcd_digit + 1,
            s_ones
        );


        //==============================================================
        // TEST 14 : STRUCTURAL VS RTL
        //==============================================================

        $display("\n==============================================");
        $display("TEST 14 : STRUCTURAL VS RTL");
        $display("==============================================");

        repeat(25)
        begin

            @(posedge clk);
            #1;

            check_4bit(
                "TENS STRUCTURAL=RTL",
                r_tens,
                s_tens
            );

            check_4bit(
                "ONES STRUCTURAL=RTL",
                r_ones,
                s_ones
            );

            check_1bit(
                "RUN STRUCTURAL=RTL",
                r_running,
                s_running
            );

        end


        //==============================================================
        // FINAL RESULT
        //==============================================================

        $display("\n==============================================");
        $display("DAY 17 VERIFICATION COMPLETE");
        $display("==============================================");

        $display("PASS COUNT = %0d", pass_count);
        $display("FAIL COUNT = %0d", fail_count);

        if(fail_count == 0)
        begin
            $display("----------------------------------------------");
            $display("RESULT : ALL TESTS PASSED");
            $display("----------------------------------------------");
        end
        else
        begin
            $display("----------------------------------------------");
            $display("RESULT : FAILURES DETECTED");
            $display("----------------------------------------------");
        end

        #20;

        $finish;

    end


    //==================================================================
    // WAVEFORM MONITOR
    //==================================================================

    initial
    begin

        $monitor(
            "TIME=%0t | CLK=%b | RESET=%b | START=%b | STOP=%b | RUN=%b | TENS=%d | ONES=%d",
            $time,
            clk,
            reset,
            start,
            stop,
            s_running,
            s_tens,
            s_ones
        );

    end

endmodule