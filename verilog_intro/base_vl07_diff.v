`timescale 1ns/1ns
// 基础语法 VL7 求两个数的差值：diff = |a - b| 或 a-b（看题意）
module diff(input wire [3:0] a, input wire [3:0] b, output wire [3:0] y);
    assign y = 4'b0;   // TODO: assign y = (a>b) ? a-b : b-a;
endmodule

//=====================================================
// 范例模块 diff_ref：参考答案（供对照学习），原模块 diff 请自行完成
// 题目：求两数之差的绝对值（大减小）
// 思路：先比较大小，再用三目选减法方向，保证结果非负
// 关键点：无符号数直接比较即可；若允许负数结果则直接 a-b
//=====================================================
module diff_ref(input wire [3:0] a, input wire [3:0] b, output wire [3:0] y);
    assign y = (a > b) ? (a - b) : (b - a);   // 大减小，差值恒为非负
endmodule
