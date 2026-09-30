`timescale 1ns/1ns
//=====================================================
// VL40 占空比50%的奇数分频
// 奇数 N 分频且保持 50% 占空比：利用上升沿与下降沿两路计数再合并
//=====================================================
module div_odd_50 #(parameter N = 5)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_out
);
    // TODO: 上升沿计数得 p、下降沿计数得 n，clk_out = p | n（或 p & n）得 50%
    always @(*) clk_out = 1'b0;
endmodule

//=====================================================
// 范例模块 div_odd_50_ref：参考答案（供对照学习），原模块请自行完成
// 题目：奇数 N 分频且 50% 占空比（示例 N=5）
// 思路：双沿合并法——上升沿计数产生 clk_p（前 (N+1)/2 拍高），
//       下降沿计数产生 clk_n（同样规则，但相位差半拍），两者相或得 50% 占空比
// 关键点：① 奇数分频单沿无法 50%：高/低半周期各占 N/2（非整数）拍；
//         ② 两路计数器各自 0~N-1，计数 <(N+1)/2 时输出高；③ clk_out = clk_p | clk_n
//=====================================================
module div_odd_50_ref #(parameter N = 5)(
    input  wire clk,
    input  wire rst_n,
    output wire clk_out
);
    localparam HALF = (N + 1) / 2;         // 高电平持续拍数（N=5 时 HALF=3）
    reg [$clog2(N)-1:0] cnt_p, cnt_n;      // 上升沿/下降沿两路计数器
    reg clk_p, clk_n;                      // 两路非 50% 中间波形

    // 上升沿计数：0~N-1 循环，计数值 < HALF 时 clk_p 为高
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_p <= 0;
            clk_p <= 1'b0;
        end
        else begin
            cnt_p <= (cnt_p == N - 1) ? 0 : cnt_p + 1'b1;
            clk_p <= (cnt_p < HALF - 1) ? 1'b1 :
                     (cnt_p == N - 1)   ? 1'b1 : 1'b0;   // 含回卷拍共 HALF 拍高
        end
    end

    // 下降沿计数：规则同上，波形相对 clk_p 后移半个 clk 周期
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_n <= 0;
            clk_n <= 1'b0;
        end
        else begin
            cnt_n <= (cnt_n == N - 1) ? 0 : cnt_n + 1'b1;
            clk_n <= (cnt_n < HALF - 1) ? 1'b1 :
                     (cnt_n == N - 1)   ? 1'b1 : 1'b0;
        end
    end

    // 两路相或：各自的高电平段拼合成完整半周期 -> 50% 占空比、N 分频
    assign clk_out = clk_p | clk_n;
endmodule
