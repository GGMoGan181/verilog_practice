`timescale 1ns/1ns
// 基础语法 VL3 奇偶校验：计算数据中 1 的个数奇偶（^ 归约）
module parity(input wire [7:0] d, output wire par);
    assign par = 1'b0;   // TODO: assign par = ^d; (偶校验) 或 ~^d
endmodule

//=====================================================
// 范例模块 parity_ref：参考答案（供对照学习），原模块 parity 请自行完成
// 题目：计算 8bit 数据中 1 的个数的奇偶性
// 思路：归约异或 ^d 把各位逐级异或，结果=1 表示 1 的个数为奇数
// 关键点：^d 奇校验、~^d 偶校验，一行归约运算代替逐位循环
//=====================================================
module parity_ref(input wire [7:0] d, output wire par);
    assign par = ^d;   // 归约异或：d[7]^d[6]^...^d[0]，1 的个数为奇时输出 1
    // 若题目要求偶校验（1 的个数为偶时输出 1）则写：assign par = ~^d;
endmodule
