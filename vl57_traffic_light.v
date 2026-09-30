`timescale 1ns/1ns
//=====================================================
// VL57 交通灯
// FSM 控制十字路口：主/支路 红绿黄 按定时切换（含黄灯过渡）
//=====================================================
module traffic_light(
    input  wire       clk,
    input  wire       rst_n,
    output reg  [2:0] main_light,   //主路 {红,黄,绿}
    output reg  [2:0] side_light    //支路 {红,黄,绿}
);
    // TODO: 状态=灯态组合 + 定时计数；到点切换（绿->黄->红->...）
    always @(*) begin main_light = 3'b0; side_light = 3'b0; end
endmodule

//=====================================================
// 范例模块 traffic_light_ref：参考答案（供对照学习），原模块请自行完成
// 题目：十字路口交通灯——主/支路 {红,黄,绿} 按定时循环切换，含黄灯过渡
// 思路：四状态 FSM + 定时计数器：
//       S0 主绿/支红(G_T拍) -> S1 主黄/支红(Y_T拍) -> S2 主红/支绿(G_T拍) -> S3 主红/支黄(Y_T拍) -> S0
// 关键点：① 一个计数器复用：每到定时值清零并切态；② 灯输出用 Moore 译码
//         （只依现态）；③ 任意时刻两路不同时绿，黄灯只在绿->红之间过渡
//=====================================================
module traffic_light_ref(
    input  wire       clk,
    input  wire       rst_n,
    output reg  [2:0] main_light,   // {红,黄,绿}，高有效
    output reg  [2:0] side_light
);
    localparam G_T = 10;    // 绿灯时长（clk 拍数）
    localparam Y_T = 3;     // 黄灯时长

    localparam S0 = 2'd0;   // 主绿 / 支红
    localparam S1 = 2'd1;   // 主黄 / 支红
    localparam S2 = 2'd2;   // 主红 / 支绿
    localparam S3 = 2'd3;   // 主红 / 支黄

    reg [1:0] state;
    reg [3:0] timer;        // 当前状态剩余定时

    // 状态机 + 定时计数：到时切换并重新装载定时值
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S0;
            timer <= G_T - 1;
        end
        else if (timer == 0) begin
            // 本状态定时到：切态，并按新状态装载定时（绿=G_T，黄=Y_T）
            state <= state + 1'b1;                       // S0->S1->S2->S3->S0 循环
            timer <= (state == S0 || state == S2) ? Y_T - 1 : G_T - 1;
        end
        else
            timer <= timer - 1'b1;                       // 未到：倒计时
    end

    // Moore 输出译码：灯态只由现态决定
    always @(*) begin
        case (state)
            S0: begin main_light = 3'b001; side_light = 3'b100; end  // 主绿 支红
            S1: begin main_light = 3'b010; side_light = 3'b100; end  // 主黄 支红
            S2: begin main_light = 3'b100; side_light = 3'b001; end  // 主红 支绿
            S3: begin main_light = 3'b100; side_light = 3'b010; end  // 主红 支黄
            default: begin main_light = 3'b100; side_light = 3'b100; end // 异常：双红安全态
        endcase
    end
endmodule
