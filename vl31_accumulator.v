`timescale 1ns/1ns
//=====================================================
// VL31 数据累加输出
// din_valid 有效时把 din 累加进 sum；clr 高电平清零
//=====================================================
module accumulator(
    input  wire       clk,
    input  wire       rst_n,
    input  wire       clr,        //同步清零
    input  wire [7:0] din,
    input  wire       din_valid,
    output reg  [7:0] sum         //累加和（溢出自然回卷）
);
    // TODO: clr 优先，否则 din_valid 时 sum <= sum + din
    always @(*) sum = 8'b0;
endmodule

//=====================================================
// 范例模块 accumulator_ref：参考答案（供对照学习），原模块请自行完成
// 题目：数据累加——din_valid 有效时 sum <= sum + din；clr 同步清零（优先于累加）
// 思路：单一时序块，优先级：复位 > 同步清零 > 累加 > 保持
// 关键点：① 8 位自然溢出回卷（模 256 加法）；② clr 是同步清零，只在时钟沿生效
//=====================================================
module accumulator_ref(
    input  wire       clk,
    input  wire       rst_n,
    input  wire       clr,
    input  wire [7:0] din,
    input  wire       din_valid,
    output reg  [7:0] sum
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            sum <= 8'd0;             // 异步复位：优先级最高
        else if (clr)
            sum <= 8'd0;             // 同步清零：优先于累加
        else if (din_valid)
            sum <= sum + din;        // 累加（溢出自然回卷）
        // din_valid=0 时不写 sum，寄存器默认保持
    end
endmodule
