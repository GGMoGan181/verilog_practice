`timescale 1ns/1ns
//=====================================================
// 华W VL4 超前进位加法器（中等）
// 4bit CLA：用生成 g=p&q、传播 p=p^q 提前算进位，避免行波延迟
//=====================================================
module lookahead_adder(
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire       cin,
    output wire [3:0] sum,
    output wire       cout
);
    // TODO: p=a^b, g=a&b; c1=g0|p0c0 ... 逐级超前; sum=p^c
    assign sum  = 4'b0;
    assign cout = 1'b0;
endmodule

//=====================================================
// 范例模块 lookahead_adder_ref：参考答案，原模块 lookahead_adder 请自行完成
// 题目：4bit 超前进位加法器：进位不等行波，由 g/p 并行展开
// 思路：g=a&b（生成）、p=a^b（传播）；
//       c1..c4 逐级展开成 g/p/cin 的与或式，全部并行可得
// 关键点：与 comb_vl02 的 CLA 同一套公式；sum = p ^ 进位
//=====================================================
module lookahead_adder_ref(
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire       cin,
    output wire [3:0] sum,
    output wire       cout
);
    wire [3:0] p, g;
    wire       c1, c2, c3;
    assign p = a ^ b;                 // 传播
    assign g = a & b;                 // 生成
    assign c1   = g[0] | p[0]&cin;
    assign c2   = g[1] | p[1]&g[0] | p[1]&p[0]&cin;
    assign c3   = g[2] | p[2]&g[1] | p[2]&p[1]&g[0] | p[2]&p[1]&p[0]&cin;
    assign cout = g[3] | p[3]&g[2] | p[3]&p[2]&g[1] | p[3]&p[2]&p[1]&g[0]
                         | p[3]&p[2]&p[1]&p[0]&cin;
    assign sum  = p ^ {c3, c2, c1, cin};
endmodule
