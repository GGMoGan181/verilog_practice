`timescale 1ns/1ns
// 入门特别版 VL5 与门：y = a & b
module and_gate(input wire a, input wire b, output wire y);
    assign y = 1'b0;   // TODO: assign y = a & b;
endmodule

//=====================================================
// 范例模块 and_gate_ref：参考答案，原模块 and_gate 请自行完成
// 题目：与门 y = a & b
// 关键点：& 按位与；单 bit 时与逻辑与 && 结果相同
//=====================================================
module and_gate_ref(input wire a, input wire b, output wire y);
    assign y = a & b;   // 与门
endmodule
