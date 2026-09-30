`timescale 1ns/1ns
//=====================================================
// VL49 脉冲同步电路
// 把源时钟域的单周期脉冲安全地同步到目的时钟域（展宽/toggle+边沿检测）
//=====================================================
module pulse_sync(
    input  wire src_clk,
    input  wire dst_clk,
    input  wire rst_n,
    input  wire pulse_in,     //源域单周期脉冲
    output reg  pulse_out     //目的域单周期脉冲
);
    // TODO: 源域脉冲->toggle 电平跨域两级同步->目的域边沿检测还原脉冲
    always @(*) pulse_out = 1'b0;
endmodule

//=====================================================
// 范例模块 pulse_sync_ref：参考答案（供对照学习），原模块请自行完成
// 题目：脉冲跨时钟域同步——源域单周期脉冲安全传递到目的域，仍为单周期脉冲
// 思路：toggle 法——① 源域：每收到一个脉冲翻转 toggle 电平；② 电平打两拍
//       同步到目的域；③ 目的域：异或检边沿（toggle 变化即还原出一个脉冲）
// 关键点：① 窄脉冲直接打拍可能被漏采，转成电平后不会丢；② 两次脉冲间隔
//       必须 > 目的域 2~3 拍，否则 toggle 翻两次等于没翻（丢脉冲）
//=====================================================
module pulse_sync_ref(
    input  wire src_clk,
    input  wire dst_clk,
    input  wire rst_n,
    input  wire pulse_in,
    output reg  pulse_out
);
    reg toggle;           // 源域：每个输入脉冲翻转一次
    reg t_s1, t_s2, t_s3; // 目的域：两级同步 + 延迟一拍供边沿检测

    // 源域：脉冲 -> 电平翻转（脉冲的"存在"编码进 toggle 的"变化"）
    always @(posedge src_clk or negedge rst_n) begin
        if (!rst_n)
            toggle <= 1'b0;
        else if (pulse_in)
            toggle <= ~toggle;
    end

    // 目的域：两级同步消除亚稳态，第三拍用于异或检边沿
    always @(posedge dst_clk or negedge rst_n) begin
        if (!rst_n) begin
            t_s1      <= 1'b0;
            t_s2      <= 1'b0;
            t_s3      <= 1'b0;
            pulse_out <= 1'b0;
        end
        else begin
            t_s1      <= toggle;         // 第一级同步
            t_s2      <= t_s1;           // 第二级同步（已稳定）
            t_s3      <= t_s2;           // 延迟一拍
            pulse_out <= t_s2 ^ t_s3;    // toggle 发生变化的那一拍输出单周期脉冲
        end
    end
endmodule
