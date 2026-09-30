`timescale 1ns/1ns
//=====================================================
// 华W VL3 状态机与时钟分频（中等）
// 用 FSM 控制分频比/使能，输出分频时钟
//=====================================================
module fsm_clock_div #(parameter N = 4)(
    input  wire clk,
    input  wire rst_n,
    input  wire en,
    output reg  clk_div
);
    // TODO: FSM 状态循环 N 次翻转 clk_div（或按状态表控制分频）
    always @(*) clk_div = 1'b0;
endmodule

//=====================================================
// 范例模块 fsm_clock_div_ref：参考答案，原模块 fsm_clock_div 请自行完成
// 题目：FSM 控制分频：en 有效时状态循环 N 次翻转一次输出（2N 分频）
// 思路：把 0~N-1 看成 N 个状态循环跳转，回到 S0 的那拍翻转 clk_div；
//       en=0 时状态机停住，输出保持
// 关键点：翻转条件=计数回卷那一拍；输出占空比 50%
//=====================================================
module fsm_clock_div_ref #(parameter N = 4)(
    input  wire clk,
    input  wire rst_n,
    input  wire en,
    output reg  clk_div
);
    reg [7:0] cnt;   // FSM 状态（0~N-1 循环）
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 8'd0;
            clk_div <= 1'b0;
        end
        else if (en) begin
            if (cnt == N-1) begin      // 状态回卷：翻转输出
                cnt     <= 8'd0;
                clk_div <= ~clk_div;
            end
            else
                cnt <= cnt + 1'b1;     // 状态前进
        end
    end
endmodule
