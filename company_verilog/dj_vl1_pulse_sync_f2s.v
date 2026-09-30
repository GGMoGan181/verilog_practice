`timescale 1ns/1ns
//=====================================================
// DJ VL1 脉冲同步器（快到慢）（中等）
// 快时钟域单周期脉冲 -> 慢时钟域：需展宽/toggle 保证慢域能采到
//=====================================================
module pulse_sync_f2s(
    input  wire fast_clk,
    input  wire slow_clk,
    input  wire rst_n,
    input  wire pulse_in,      //快域单周期脉冲
    output reg  pulse_out      //慢域单周期脉冲
);
    // TODO: 快域脉冲置电平/toggle -> 慢域两级同步 -> 边沿检测还原脉冲
    always @(*) pulse_out = 1'b0;
endmodule

//=====================================================
// 范例模块 pulse_sync_f2s_ref：参考答案，原模块 pulse_sync_f2s 请自行完成
// 题目：快域单周期脉冲跨到慢域（脉冲可能比慢周期短，直接采会丢）
// 思路：toggle 法：快域每来一个脉冲翻转一次 toggle（脉冲→电平变化）；
//       慢域对 toggle 两级同步防亚稳态，再异或边沿检测还原成脉冲
// 关键点：① 两级同步是跨域底线；② 异或 sync2^sync3 得单拍脉冲；
//         ③ 两个脉冲间隔必须大于慢域 3 拍，否则 toggle 法会合并脉冲
//=====================================================
module pulse_sync_f2s_ref(
    input  wire fast_clk,
    input  wire slow_clk,
    input  wire rst_n,
    input  wire pulse_in,
    output reg  pulse_out
);
    reg toggle;              // 快域 toggle 信号
    reg sync1, sync2, sync3; // 慢域同步链 + 边沿检测寄存
    // 快域：脉冲到来即翻转
    always @(posedge fast_clk or negedge rst_n)
        if (!rst_n) toggle <= 1'b0;
        else        toggle <= toggle ^ pulse_in;
    // 慢域：两级同步 + 异或还原脉冲（同一块只驱动自己这组信号）
    always @(posedge slow_clk or negedge rst_n)
        if (!rst_n) begin
            sync1 <= 1'b0; sync2 <= 1'b0; sync3 <= 1'b0;
            pulse_out <= 1'b0;
        end
        else begin
            sync1 <= toggle;          // 第一级同步
            sync2 <= sync1;           // 第二级同步（可安全使用）
            sync3 <= sync2;           // 再打一拍用于边沿检测
            pulse_out <= sync2 ^ sync3;  // 电平变化 → 单拍脉冲
        end
endmodule
