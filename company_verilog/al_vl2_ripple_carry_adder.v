`timescale 1ns/1ns
//=====================================================
// A里 VL2 串行进位加法器（简单）
// 4bit 行波进位：4 个全加器进位串联
//=====================================================
module ripple_carry_adder(
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire       cin,
    output wire [3:0] sum,
    output wire       cout
);
    // TODO: 例化4个 full_adder，c 逐级串联（或逐位 always 展开）
    assign sum  = 4'b0;
    assign cout = 1'b0;
endmodule

//=====================================================
// 范例模块 full_adder_ref / ripple_carry_adder_ref：参考答案
// 原模块 ripple_carry_adder 请自行完成
// 题目：4bit 行波进位加法器：4 个全加器进位串联
// 思路：自包含地先给一个全加器 _ref，再例化 4 片，cin 逐级串
// 关键点：进位从低位向高位逐级传递（行波）；第 3 片的 cout 即总进位
//=====================================================
module full_adder_ref(
    input  wire a, b, cin,
    output wire sum, cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | ((a ^ b) & cin);
endmodule

module ripple_carry_adder_ref(
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire       cin,
    output wire [3:0] sum,
    output wire       cout
);
    wire c0, c1, c2;   // 级间进位
    full_adder_ref u0 (.a(a[0]), .b(b[0]), .cin(cin), .sum(sum[0]), .cout(c0));
    full_adder_ref u1 (.a(a[1]), .b(b[1]), .cin(c0),  .sum(sum[1]), .cout(c1));
    full_adder_ref u2 (.a(a[2]), .b(b[2]), .cin(c1),  .sum(sum[2]), .cout(c2));
    full_adder_ref u3 (.a(a[3]), .b(b[3]), .cin(c2),  .sum(sum[3]), .cout(cout));
endmodule
