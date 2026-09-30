`timescale 1ns/1ns
// 入门特别版 VL8 逻辑运算：组合逻辑表达式（与/或/非混合）
module logic_ops(input wire a, input wire b, input wire c, output wire y);
    assign y = 1'b0;   // TODO: 如 y = (a & b) | ~c;
endmodule

//=====================================================
// 范例模块 logic_ops_ref：参考答案，原模块 logic_ops 请自行完成
// 题目：与/或/非混合组合表达式（本例 y=(a&b)|~c）
// 关键点：优先级 ~ > & > ^ > |；混写时加括号保证可读性与正确性
//=====================================================
module logic_ops_ref(input wire a, input wire b, input wire c, output wire y);
    assign y = (a & b) | ~c;   // 与或非混合表达式
endmodule
