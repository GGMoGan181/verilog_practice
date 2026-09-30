`timescale 1ns/1ns
//=====================================================
// VL42 无占空比要求的奇数分频
// 奇数 N 分频，不要求 50% 占空比：单沿计数即可（高电平 1 拍或 (N±1)/2 拍）
//=====================================================
module div_odd #(parameter N = 5)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_out
);
    // TODO: 上升沿计数 0~N-1；某区间置 clk_out=1，其余为0（占空比不限）
    always @(*) clk_out = 1'b0;
endmodule

//=====================================================
// 范例模块 div_odd_ref：参考答案（供对照学习），原模块请自行完成
// 题目：奇数 N 分频，不要求占空比——单沿计数即可
// 思路：计数 0~N-1 循环，计到 N-1 时翻转输出：周期 = N 个 clk，
//       高/低电平各占 (N±1)/2 拍，占空比接近但非精确 50%
// 关键点：① 与 50% 版（双沿合并）的区别：只用上升沿单路计数，资源更省；
//         ② 若只要窄脉冲，可改为 cnt==0 时拉高一拍其余为 0
//=====================================================
module div_odd_ref #(parameter N = 5)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_out
);
    reg [$clog2(N)-1:0] cnt;   // 0~N-1 循环计数器

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 0;
            clk_out <= 1'b0;
        end
        else if (cnt == N - 1) begin
            cnt     <= 0;              // 计满 N 拍：回卷
            clk_out <= ~clk_out;       // 翻转：输出周期 = N 个 clk
        end
        else
            cnt <= cnt + 1'b1;
    end
endmodule
