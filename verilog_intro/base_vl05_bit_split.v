`timescale 1ns/1ns
// 基础语法 VL5 位拆分与运算：把向量拆成高/低半字节分别运算
module bit_split(input wire [7:0] a, output wire [3:0] hi, output wire [3:0] lo);
    assign hi = 4'b0;   // TODO: assign hi = a[7:4];
    assign lo = 4'b0;   // TODO: assign lo = a[3:0];
endmodule

//=====================================================
// 范例模块 bit_split_ref：参考答案（供对照学习），原模块 bit_split 请自行完成
// 题目：把 8bit 向量拆成高/低两个 4bit 半字节
// 思路：部分选择（part select）直接切位段
// 关键点：位段边界 [7:4] / [3:0] 不能写反，位宽与端口一致
//=====================================================
module bit_split_ref(input wire [7:0] a, output wire [3:0] hi, output wire [3:0] lo);
    assign hi = a[7:4];   // 高半字节
    assign lo = a[3:0];   // 低半字节
endmodule
