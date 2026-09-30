`timescale 1ns/1ns
//=====================================================
// 哲K VL4 序列发生器（中等）
// 周期性产生固定比特序列（如 01110100...），每拍输出一位
//=====================================================
module sequence_generator #(parameter LEN = 8, pattern = 8'b0111_0100)(
    input  wire clk,
    input  wire rst_n,
    output reg  seq_out      //每拍输出序列的一位，循环往复
);
    // TODO: 计数器 0~LEN-1 循环，seq_out = pattern[cnt]（或移位寄存器循环）
    always @(*) seq_out = 1'b0;
endmodule

//=====================================================
// 范例模块 sequence_generator_ref：参考答案，原模块 sequence_generator 请自行完成
// 题目：周期性循环输出固定比特序列，每拍一位
// 思路：模 LEN 计数器当地址，查 pattern 的对应位（ROM 查表法）；
//       等价写法：循环左移寄存器
// 关键点：计数器到 LEN-1 回卷；pattern[cnt] 位选即查表
//=====================================================
module sequence_generator_ref #(parameter LEN = 8, pattern = 8'b0111_0100)(
    input  wire clk,
    input  wire rst_n,
    output reg  seq_out
);
    reg [7:0] cnt;   // 模 LEN 计数器（LEN≤256 时 8bit 够）
    always @(posedge clk or negedge rst_n)
        if (!rst_n) cnt <= 8'd0;
        else        cnt <= (cnt == LEN-1) ? 8'd0 : cnt + 1'b1;
    always @(*) seq_out = pattern[cnt];   // 查表输出当前位
endmodule
