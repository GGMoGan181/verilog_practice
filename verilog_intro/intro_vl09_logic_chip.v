`timescale 1ns/1ns
// 入门特别版 VL9 模拟逻辑芯片：用门级/表达式复现某芯片功能(如74系列)
module logic_chip(input wire a, input wire b, input wire c, output wire y);
    assign y = 1'b0;   // TODO: 按芯片真值表/内部结构写表达式
endmodule

//=====================================================
// 范例模块 logic_chip_ref：参考答案，原模块 logic_chip 请自行完成
// 题目：复现某逻辑芯片（如 74 系列）功能：与-或-非 结构示例
// 思路：芯片内部=两级与门进一个或非门 → y = ~((a&b)|(b&c))
// 关键点：先按芯片内部结构分级写中间 wire，再合并，不易错
//=====================================================
module logic_chip_ref(input wire a, input wire b, input wire c, output wire y);
    wire and1, and2;                 // 芯片内部两个与门输出
    assign and1 = a & b;             // 第一片与门
    assign and2 = b & c;             // 第二片与门
    assign y    = ~(and1 | and2);    // 或非输出（与-或-非 结构）
endmodule
