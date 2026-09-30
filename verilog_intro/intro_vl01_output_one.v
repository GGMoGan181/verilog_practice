`timescale 1ns/1ns
// 入门特别版 VL1 输出1：常量输出 1
module output_one(output wire y);
    assign y = 1'b0;   // TODO: assign y = 1'b1;
endmodule

//=====================================================
// 范例模块 output_one_ref：参考答案，原模块 output_one 请自行完成
// 题目：输出常量 1
// 关键点：常量要带位宽写 1'b1，不要裸写 1
//=====================================================
module output_one_ref(output wire y);
    assign y = 1'b1;   // 常量 1
endmodule
