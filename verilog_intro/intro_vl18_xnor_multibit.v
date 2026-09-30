`timescale 1ns/1ns
// 入门特别版 VL18 多位信号xnor：同或 y = ~(a ^ b) 即 a ~^ b
module xnor_multibit(input wire [3:0] a, input wire [3:0] b, output wire [3:0] y);
    assign y = 4'b0;   // TODO: assign y = ~(a ^ b); 或 a ~^ b
endmodule

//=====================================================
// 范例模块 xnor_multibit_ref：参考答案，原模块 xnor_multibit 请自行完成
// 题目：多位同或（xnor）：对应位相同得 1
// 思路：异或取反即同或；Verilog 也支持直接写 ~^
// 关键点：~(a^b) 与 a~^b 等价，都是逐位进行
//=====================================================
module xnor_multibit_ref(input wire [3:0] a, input wire [3:0] b, output wire [3:0] y);
    assign y = ~(a ^ b);   // 等价写法：assign y = a ~^ b;
endmodule
