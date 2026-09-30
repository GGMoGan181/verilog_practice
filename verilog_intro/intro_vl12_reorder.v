`timescale 1ns/1ns
// 入门特别版 VL12 信号顺序调整：用位选择/拼接重排位序
module reorder(input wire [3:0] a, output wire [3:0] y);
    assign y = 4'b0;   // TODO: 如 y = {a[0],a[1],a[2],a[3]};
endmodule

//=====================================================
// 范例模块 reorder_ref：参考答案，原模块 reorder 请自行完成
// 题目：用位选择+拼接重排位序（本例：完全反序）
// 思路：拼接符 {} 里按"目标顺序"从左到右列出各源位
// 关键点：{} 内最左是结果最高位；逐位列写最直观不易错
//=====================================================
module reorder_ref(input wire [3:0] a, output wire [3:0] y);
    assign y = {a[0], a[1], a[2], a[3]};   // 位序反排
endmodule
