`timescale 1ns/1ns
//============================================================
// sequence_detect3 (011100 固定6位分组 FSM) 的 testbench
// 用例：
//   011100 -> match          整组命中
//   011101 -> not_match      末位不符
//   101110 -> not_match      首位不符（题目例子：不考虑后五位）
//   111011 -> not_match      跨组陷阱第1组
//   100111 -> not_match      跨组陷阱第2组（两组拼接含跨边界的011100，必须不误报）
//   011100 -> match          再次命中
//============================================================
module sequence_detect_tb;
    reg  clk, rst_n, a;
    wire match, not_match;
    integer err;

    sequence_detect dut(
        .clk(clk),
        .rst_n(rst_n),
        .a(a),
        .match(match),
        .not_match(not_match)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    //送一组 6 位（g[5] 为组内第1位），并在组末采样 match/not_match
    task send_group(input [5:0] g, input exp_m, input exp_nm);
        integer i;
        begin
            for (i = 5; i >= 0; i = i - 1) begin
                a = g[i];            //在 negedge 后、posedge 前稳定好本位
                @(posedge clk);      //本拍消耗该位
                if (i == 0) begin
                    #1;              //组末输出在该 posedge 更新，稍后采样
                    if (match !== exp_m || not_match !== exp_nm) begin
                        err = err + 1;
                        $display("FAIL group=%b  match=%b not_match=%b  expect %b/%b",
                                 g, match, not_match, exp_m, exp_nm);
                    end
                    else
                        $display("PASS group=%b  match=%b not_match=%b", g, match, not_match);
                end
                @(negedge clk);      //移到 negedge，准备下一位
            end
        end
    endtask

    initial begin
        err   = 0;
        rst_n = 0;
        a     = 0;
        repeat (2) @(negedge clk);   //保持复位两个周期
        rst_n = 1;                   //在 negedge 释放复位，cnt=0/state=IDLE

        send_group(6'b011100, 1'b1, 1'b0);
        send_group(6'b011101, 1'b0, 1'b1);
        send_group(6'b101110, 1'b0, 1'b1);
        send_group(6'b111011, 1'b0, 1'b1);
        send_group(6'b100111, 1'b0, 1'b1);
        send_group(6'b011100, 1'b1, 1'b0);

        if (err == 0) $display("==== ALL PASS ====");
        else          $display("==== %0d ERROR(S) ====", err);
        $finish;
    end
endmodule
