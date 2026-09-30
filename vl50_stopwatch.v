`timescale 1ns/1ns
//=====================================================
// VL50 简易秒表
// 使能 run 时按 1s 累加计数（假设 clk 已分频到 1Hz 或内部再分频），BCD 显示秒
//=====================================================
module stopwatch(
    input  wire       clk,
    input  wire       rst_n,
    input  wire       run,        //启动/暂停
    output reg  [3:0] sec_ones,   //秒个位(BCD)
    output reg  [3:0] sec_tens    //秒十位(BCD)
);
    // TODO: run 时每秒 BCD 加1（0-99 回卷）；rst_n 清零
    always @(*) begin sec_ones = 4'b0; sec_tens = 4'b0; end
endmodule

//=====================================================
// 范例模块 stopwatch_ref：参考答案（供对照学习），原模块请自行完成
// 题目：简易秒表——run=1 时每秒 BCD 加 1，计到 99 回卷；复位清零
// 思路：① 内部计数器产生秒脉冲（参数化，默认按 1Hz 时钟则每拍即 1 秒）；
//       ② BCD 十位/个位分开进位：个位到 9 归零、十位加 1；十位到 9 且个位到 9 双双归零
// 关键点：① BCD 加法不是普通二进制加：逢 10 进位而非逢 16；② run=0 时暂停保持
//=====================================================
module stopwatch_ref(
    input  wire       clk,        // 假定 1Hz（或外部已分频到秒脉冲）
    input  wire       rst_n,
    input  wire       run,
    output reg  [3:0] sec_ones,   // 秒个位 BCD 0~9
    output reg  [3:0] sec_tens    // 秒十位 BCD 0~9
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sec_ones <= 4'd0;     // 复位清零
            sec_tens <= 4'd0;
        end
        else if (run) begin       // run=1 走表，run=0 暂停（不写即保持）
            if (sec_ones == 4'd9) begin
                sec_ones <= 4'd0;                       // 个位满 10 归零
                if (sec_tens == 4'd9)
                    sec_tens <= 4'd0;                   // 99 秒回卷到 00
                else
                    sec_tens <= sec_tens + 1'b1;        // 十位进位
            end
            else
                sec_ones <= sec_ones + 1'b1;            // 个位正常递增
        end
    end
endmodule
