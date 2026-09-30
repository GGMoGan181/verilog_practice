`timescale 1ns/1ns
// 入门特别版 VL10 逻辑运算2：另一组组合逻辑表达式
module logic_ops2(input wire a, input wire b, input wire c, output wire y);
    assign y = 1'b0;   // TODO: 按题意写表达式
endmodule

//=====================================================
// 范例模块 logic_ops2_ref：参考答案，原模块 logic_ops2 请自行完成
// 题目：另一组组合表达式（本例：三输入异或/奇校验）
// 关键点：异或满足交换结合，连写 a^b^c 即奇个 1 时为 1
//=====================================================
module logic_ops2_ref(input wire a, input wire b, input wire c, output wire y);
    assign y = a ^ b ^ c;   // 三输入异或：1 的个数为奇时输出 1
endmodule
