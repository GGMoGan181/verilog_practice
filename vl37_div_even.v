`timescale 1ns/1ns
//=====================================================
// VL37 时钟分频（偶数）
// 对 clk 做 N 分频（N 为偶数），输出 50% 占空比 clk_out
//=====================================================
module div_even #(parameter N = 4)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_out
);
    // TODO: 计数到 N/2-1 翻转 clk_out（偶数分频天然 50%）
    always @(*) clk_out = 1'b0;
endmodule

//=====================================================
// 范例模块 div_even_ref：参考答案（供对照学习），原模块请自行完成
// 题目：偶数 N 分频，输出 50% 占空比时钟
// 思路：计数 0~N/2-1 循环，计满翻转一次 clk_out——半个输出周期高、半个低
// 关键点：① 计数器位宽 $clog2(N/2)；② 翻转条件 cnt==N/2-1 时同时清零计数；
//         ③ 偶数分频只需单沿计数，天然 50%（奇数才需双沿合并）
//=====================================================
module div_even_ref #(parameter N = 4)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_out
);
    localparam HALF = N / 2;                       // 半周期计数值
    reg [$clog2(HALF)-1:0] cnt;                    // 0 ~ HALF-1 循环计数器

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 0;
            clk_out <= 1'b0;
        end
        else if (cnt == HALF - 1) begin
            cnt     <= 0;                          // 计满半周期：清零重计
            clk_out <= ~clk_out;                   // 翻转输出 -> 周期 = N 个 clk
        end
        else
            cnt <= cnt + 1'b1;
    end
endmodule
