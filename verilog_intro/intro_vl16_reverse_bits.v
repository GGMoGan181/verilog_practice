`timescale 1ns/1ns
// 入门特别版 VL16 信号反转输出：位序反转（MSB<->LSB 对调）
module reverse_bits(input wire [3:0] a, output wire [3:0] y);
    assign y = 4'b0;   // TODO: assign y = {a[0],a[1],a[2],a[3]};
endmodule

//=====================================================
// 范例模块 reverse_bits_ref：参考答案，原模块 reverse_bits 请自行完成
// 题目：位序反转（MSB 与 LSB 对调）
// 思路：拼接时按 a[0]→a[3] 顺序排，即把原 LSB 放到结果 MSB
// 关键点：与 intro_vl12 同技巧；宽向量可考虑 generate/for 反转
//=====================================================
module reverse_bits_ref(input wire [3:0] a, output wire [3:0] y);
    assign y = {a[0], a[1], a[2], a[3]};   // 完全反序
endmodule
