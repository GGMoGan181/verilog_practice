`timescale 1ns/1ns
//=====================================================
// VL55 Johnson Counter（扭环计数器）
// 末位取反反馈到首位，2N 个状态循环
//=====================================================
module johnson_counter #(parameter N = 4)(
    input  wire        clk,
    input  wire        rst_n,
    output reg  [N-1:0] q
);
    // TODO: q <= {~q[0], q[N-1:1]}（末位取反入首位）
    always @(*) q = {N{1'b0}};
endmodule

//=====================================================
// 范例模块 johnson_counter_ref：参考答案（供对照学习），原模块请自行完成
// 题目：Johnson 扭环计数器——末位取反反馈到首位，2N 个状态循环
// 思路：右移移位寄存器，反馈路径插入反相器：q <= {~q[0], q[N-1:1]}
// 关键点：① N=4 时序列：0000->1000->1100->1110->1111->0111->0011->0001->0000（8 态）；
//         ② 相邻状态只变 1 位（无毛刺译码）；③ 复位必须全 0（否则可能进入无效环）
//=====================================================
module johnson_counter_ref #(parameter N = 4)(
    input  wire         clk,
    input  wire         rst_n,
    output reg  [N-1:0] q
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= {N{1'b0}};              // 复位全 0：从有效状态启动
        else
            q <= {~q[0], q[N-1:1]};      // 右移：末位（q[0]）取反后送入首位
    end
endmodule
