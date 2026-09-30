`timescale 1ns/1ns
// 入门特别版 VL7 XOR门：y = a ^ b
module xor_gate(input wire a, input wire b, output wire y);
    assign y = 1'b0;   // TODO: assign y = a ^ b;
endmodule

//=====================================================
// 范例模块 xor_gate_ref：参考答案，原模块 xor_gate 请自行完成
// 题目：XOR 门 y = a ^ b
// 关键点：异或=不相同为 1；同或为 ~^ 或 ^(a,b) 再取反
//=====================================================
module xor_gate_ref(input wire a, input wire b, output wire y);
    assign y = a ^ b;   // 异或门
endmodule
