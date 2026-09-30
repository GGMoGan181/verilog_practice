`timescale 1ns/1ns
// 入门特别版 VL19 五到一选择器：5 输入 1 输出，3bit 选择信号
module mux5to1(input wire [4:0] d, input wire [2:0] sel, output wire y);
    assign y = 1'b0;   // TODO: case/三元 按 sel 选 d[sel]（sel<5 有效）
endmodule

//=====================================================
// 范例模块 mux5to1_ref：参考答案，原模块 mux5to1 请自行完成
// 题目：5 选 1：sel 为 0~4 时输出 d[sel]，其余编码输出 0
// 思路：先判 sel 合法性再位选，避免选到 d[5..7] 越界位
// 关键点：3bit sel 有 8 种编码但只有 5 种有效，非法编码要给默认值
//=====================================================
module mux5to1_ref(input wire [4:0] d, input wire [2:0] sel, output wire y);
    assign y = (sel <= 3'd4) ? d[sel] : 1'b0;   // 合法编码位选，非法输出 0
endmodule
