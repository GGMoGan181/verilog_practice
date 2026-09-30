`timescale 1ns/1ns
//=====================================================
// 哲K VL1 根据RTL图编写Verilog程序（中等）
// 给定 RTL 电路图（寄存器/乘法器/选择器等），用 Verilog 描述
// 注意：端口以题目所给 RTL 图为准，此处为通用骨架
//=====================================================
module rtl_program(
    input  wire       clk,
    input  wire       rst_n,
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       sel,
    output reg  [7:0] y
);
    // TODO: 按 RTL 图连接：组合逻辑用 assign/always@(*)，寄存器用 always@(posedge)
    always @(*) y = 8'b0;
endmodule

//=====================================================
// 范例模块 rtl_program_ref：参考答案，原模块 rtl_program 请自行完成
// 题目：按 RTL 图写 Verilog：组合运算 + 输出寄存器的典型结构
// 思路：RTL 图 = 组合运算块（ mux/加法/与 ）后接一个 D 触发器；
//       本例：sel 选 (a+b) 或 (a&b)，结果拍入输出寄存器 y
// 关键点：图里每个寄存器对应一个 always@(posedge)；
//         纯连线/运算用 assign；具体运算以题目 RTL 图为准
//=====================================================
module rtl_program_ref(
    input  wire       clk,
    input  wire       rst_n,
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       sel,
    output reg  [7:0] y
);
    wire [7:0] comb;                       // 组合运算块输出
    assign comb = sel ? (a + b) : (a & b); // 选择器+运算器（按图替换）
    always @(posedge clk or negedge rst_n) // 输出寄存器
        if (!rst_n) y <= 8'b0;
        else        y <= comb;
endmodule
