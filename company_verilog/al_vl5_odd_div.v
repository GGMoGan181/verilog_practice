`timescale 1ns/1ns
//=====================================================
// A里 VL5 任意奇数倍时钟分频（中等）
// 对 clk 做 N 分频（N 为任意奇数）；可不要求50%，或双沿合并得50%
//=====================================================
module odd_div #(parameter N = 5)(   // N 为奇数
    input  wire clk,
    input  wire rst_n,
    output reg  clk_out
);
    // TODO: 计数 0~N-1 翻转/区间输出；要50%则上升沿+下降沿两路合并
    always @(*) clk_out = 1'b0;
endmodule

//=====================================================
// 范例模块 odd_div_ref：参考答案，原模块 odd_div 请自行完成
// 题目：奇数 N 分频且 50% 占空比
// 思路：经典双沿法：同一个 0~N-1 计数器，
//       上升沿采样得 cp、下降沿采样得 cn（错开半拍），
//       两路"前 (N+1)/2 拍为高"的波形或起来即 50% 占空比
// 关键点：奇数分频单沿做不到 50%，必须双沿合并；
//         计数器模 N 回卷
//=====================================================
module odd_div_ref #(parameter N = 5)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_out
);
    reg [7:0] cnt;      // 0~N-1 计数器
    reg       cp, cn;   // 上升沿/下降沿两路分频波形
    // 模 N 计数器
    always @(posedge clk or negedge rst_n)
        if (!rst_n) cnt <= 8'd0;
        else        cnt <= (cnt == N-1) ? 8'd0 : cnt + 1'b1;
    // 上升沿采样：前 (N+1)/2 拍高
    always @(posedge clk or negedge rst_n)
        if (!rst_n) cp <= 1'b0;
        else        cp <= (cnt < (N+1)/2);
    // 下降沿采样：同表达式错开半拍
    always @(negedge clk or negedge rst_n)
        if (!rst_n) cn <= 1'b0;
        else        cn <= (cnt < (N+1)/2);
    // 双沿合并得 50% 占空比
    always @(*) clk_out = cp | cn;
endmodule
