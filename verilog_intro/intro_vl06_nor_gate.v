`timescale 1ns/1ns
// 入门特别版 VL6 NOR门：y = ~(a | b)
module nor_gate(input wire a, input wire b, output wire y);
    assign y = 1'b0;   // TODO: assign y = ~(a | b);
endmodule

//=====================================================
// 范例模块 nor_gate_ref：参考答案，原模块 nor_gate 请自行完成
// 题目：NOR 门 y = ~(a|b)
// 关键点：括号必须加：~a|b 是"非a或b"，与或非门不同
//=====================================================
module nor_gate_ref(input wire a, input wire b, output wire y);
    assign y = ~(a | b);   // 先或后非
endmodule
