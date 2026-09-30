`timescale 1ns/1ns
// 组合逻辑 VL2 4bit超前进位加法器：CLA（g/p 提前进位）
module cla4(input wire [3:0] a, input wire [3:0] b, input wire cin,
            output wire [3:0] sum, output wire cout);
    assign sum  = 4'b0;   // TODO: p=a^b,g=a&b, 超前进位
    assign cout = 1'b0;
endmodule

//=====================================================
// 范例模块 cla4_ref：参考答案（供对照学习），原模块 cla4 请自行完成
// 题目：4bit 超前进位加法器（CLA）：进位不逐级等待，由 g/p 提前算出
// 思路：生成 g=a&b、传播 p=a^b，把每级进位展开成只与 cin 有关的与或式
// 关键点：c1..c4 全部由 g/p/cin 并行算出，无进位链，速度快
//=====================================================
module cla4_ref(input wire [3:0] a, input wire [3:0] b, input wire cin,
                output wire [3:0] sum, output wire cout);
    wire [3:0] p, g;                 // 传播/生成信号
    wire       c1, c2, c3;           // 各级进位（c0 即 cin）
    assign p = a ^ b;                // 传播：该位能把进位传下去
    assign g = a & b;                // 生成：该位自己产生进位
    // 进位展开式（超前进位核心）
    assign c1   = g[0] | p[0]&cin;
    assign c2   = g[1] | p[1]&g[0] | p[1]&p[0]&cin;
    assign c3   = g[2] | p[2]&g[1] | p[2]&p[1]&g[0] | p[2]&p[1]&p[0]&cin;
    assign cout = g[3] | p[3]&g[2] | p[3]&p[2]&g[1] | p[3]&p[2]&p[1]&g[0]
                         | p[3]&p[2]&p[1]&p[0]&cin;
    assign sum  = p ^ {c3, c2, c1, cin};   // 和 = 传播 ^ 进位
endmodule
