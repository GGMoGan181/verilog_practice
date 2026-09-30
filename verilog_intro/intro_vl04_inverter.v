`timescale 1ns/1ns
// 入门特别版 VL4 反相器：y = ~a
module inverter(input wire a, output wire y);
    assign y = 1'b0;   // TODO: assign y = ~a;
endmodule

//=====================================================
// 范例模块 inverter_ref：参考答案，原模块 inverter 请自行完成
// 题目：反相器 y = ~a
// 关键点：~ 是按位取反；单 bit 上等价于逻辑非 !
//=====================================================
module inverter_ref(input wire a, output wire y);
    assign y = ~a;   // 按位取反
endmodule
