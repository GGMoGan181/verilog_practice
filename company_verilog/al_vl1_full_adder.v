`timescale 1ns/1ns
//=====================================================
// A里 VL1 全加器（简单）
// 1bit 全加：sum = a^b^cin, cout = a&b | (a^b)&cin
//=====================================================
module full_adder(
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    // TODO: assign sum = a^b^cin; assign cout = (a&b)|((a^b)&cin);
    assign sum  = 1'b0;
    assign cout = 1'b0;
endmodule

//=====================================================
// 范例模块 full_adder_ref：参考答案，原模块 full_adder 请自行完成
// 题目：1bit 全加器
// 思路：sum 是三输入异或；cout = 本位生成(a&b) + 本位传播(a^b)与进位之与
// 关键点：这两个式子是行波/超前进位加法器的基础单元
//=====================================================
module full_adder_ref(
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    assign sum  = a ^ b ^ cin;              // 和：三输入异或
    assign cout = (a & b) | ((a ^ b) & cin); // 进位：生成 | 传播&cin
endmodule
