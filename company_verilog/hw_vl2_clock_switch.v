`timescale 1ns/1ns
//=====================================================
// 华W VL2 时钟切换（中等）
// 无毛刺时钟 MUX：在两路时钟间切换，避免 glitch（先关后开/握手）
//=====================================================
module clock_switch(
    input  wire clk_a,
    input  wire clk_b,
    input  wire sel,        //0=clk_a,1=clk_b
    input  wire rst_n,
    output wire clk_out
);
    // TODO: 用两级同步+门控使能，在目标时钟沿切换，保证无毛刺
    assign clk_out = 1'b0;
endmodule

//=====================================================
// 范例模块 clock_switch_ref：参考答案，原模块 clock_switch 请自行完成
// 题目：两路时钟无毛刺切换
// 思路：经典门控法：sel 分别在 clk_a/clk_b 域内（用下降沿）两级同步，
//       两路使能交叉互锁保证不同时开；使能只在各自时钟低电平期间变化，
//       与门门控后或起来输出，不会有半截脉冲/glitch
// 关键点：① 切换瞬间可能两路都关（有 gap 但无毛刺，安全）；
//         ② 同步用下降沿：保证使能在时钟低电平期间稳定变化
//=====================================================
module clock_switch_ref(
    input  wire clk_a,
    input  wire clk_b,
    input  wire sel,
    input  wire rst_n,
    output wire clk_out
);
    reg a1, a2;   // ~sel 在 clk_a 域两级同步
    reg b1, b2;   // sel  在 clk_b 域两级同步
    wire en_a, en_b;
    always @(negedge clk_a or negedge rst_n)
        if (!rst_n) begin a1 <= 1'b0; a2 <= 1'b0; end
        else begin a1 <= ~sel; a2 <= a1; end
    always @(negedge clk_b or negedge rst_n)
        if (!rst_n) begin b1 <= 1'b0; b2 <= 1'b0; end
        else begin b1 <= sel;  b2 <= b1; end
    assign en_a = a2 & ~b2;              // 交叉互锁：绝不同时为1
    assign en_b = b2 & ~a2;
    assign clk_out = (clk_a & en_a) | (clk_b & en_b);   // 门控后或
endmodule
