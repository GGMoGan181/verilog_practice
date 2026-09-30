`timescale 1ns/1ns
// 入门特别版 VL14 对信号按位操作：逐位与/或/非/异或
module bitwise_op(input wire [3:0] a, input wire [3:0] b, output wire [3:0] y);
    assign y = 4'b0;   // TODO: 如 y = a & b; / a ^ b;
endmodule

//=====================================================
// 范例模块 bitwise_op_ref：参考答案，原模块 bitwise_op 请自行完成
// 题目：对两个 4bit 信号做按位运算（本例：按位与）
// 思路：& | ^ ~ 都是逐位独立进行，位宽保持不变
// 关键点：换题意只需换运算符：a|b 按位或、a^b 按位异或、~a 按位取反
//=====================================================
module bitwise_op_ref(input wire [3:0] a, input wire [3:0] b, output wire [3:0] y);
    assign y = a & b;   // 按位与（题意要或/异或就换 | 或 ^）
endmodule
