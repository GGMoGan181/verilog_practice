`timescale 1ns/1ns
// 入门特别版 VL15 信号级联合并：用拼接符 {} 合并多个信号
module concat_sig(input wire [1:0] a, input wire [1:0] b, output wire [3:0] y);
    assign y = 4'b0;   // TODO: assign y = {a, b};
endmodule

//=====================================================
// 范例模块 concat_sig_ref：参考答案，原模块 concat_sig 请自行完成
// 题目：用拼接符 {} 把两个 2bit 信号合并成 4bit
// 思路：{} 内从左到右依次排到结果的高位→低位
// 关键点：总位宽=各段之和；{a,b} 中 a 占高 2 位
//=====================================================
module concat_sig_ref(input wire [1:0] a, input wire [1:0] b, output wire [3:0] y);
    assign y = {a, b};   // a 拼在高半，b 拼在低半
endmodule
