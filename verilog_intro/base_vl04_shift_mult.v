`timescale 1ns/1ns
// 基础语法 VL4 移位运算与乘法：左移=乘2，右移=除2
module shift_mult(input wire [7:0] a, output wire [8:0] mul2, output wire [7:0] div2);
    assign mul2 = 9'b0;   // TODO: assign mul2 = {a,1'b0}; 或 a<<1
    assign div2 = 8'b0;   // TODO: assign div2 = a >> 1;
endmodule

//=====================================================
// 范例模块 shift_mult_ref：参考答案（供对照学习），原模块 shift_mult 请自行完成
// 题目：用移位实现乘 2 / 除 2
// 思路：左移 1 位=乘2（低位补0），右移 1 位=除2（高位补0）
// 关键点：乘 2 可能溢出 8bit，结果位宽要扩到 9bit；
//         拼接 {a,1'b0} 与 a<<1 等价，且位宽自然扩展
//=====================================================
module shift_mult_ref(input wire [7:0] a, output wire [8:0] mul2, output wire [7:0] div2);
    assign mul2 = {a, 1'b0};   // 左移1位=乘2：拼接自动扩到 9bit，不丢进位
    assign div2 = a >> 1;      // 逻辑右移1位=除2：高位补0，舍掉余数
endmodule
