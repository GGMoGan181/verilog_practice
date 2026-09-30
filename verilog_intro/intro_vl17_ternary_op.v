`timescale 1ns/1ns
// 入门特别版 VL17 三元操作符：cond ? a : b 选择输出
module ternary_op(input wire sel, input wire a, input wire b, output wire y);
    assign y = 1'b0;   // TODO: assign y = sel ? a : b;
endmodule

//=====================================================
// 范例模块 ternary_op_ref：参考答案，原模块 ternary_op 请自行完成
// 题目：三元操作符 cond ? a : b 实现 2 选 1
// 思路：sel=1 选 a，sel=0 选 b，等价于一个 2 选 1 MUX
// 关键点：三元是组合逻辑，可嵌套实现多选一
//=====================================================
module ternary_op_ref(input wire sel, input wire a, input wire b, output wire y);
    assign y = sel ? a : b;   // sel=1 输出 a，否则输出 b
endmodule
