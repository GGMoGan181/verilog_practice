`timescale 1ns/1ns
// 时序逻辑 VL4 边沿检测：检测输入上升沿/下降沿（打一拍异或/与）
module edge_detect(input wire clk, input wire rst_n, input wire din,
                   output reg pos_edge, output reg neg_edge);
    // TODO: din 打一拍得 d1；pos = din & ~d1；neg = ~din & d1
    always @(*) begin pos_edge = 1'b0; neg_edge = 1'b0; end
endmodule

//=====================================================
// 范例模块 edge_detect_ref：参考答案，原模块 edge_detect 请自行完成
// 题目：检测 din 的上升沿/下降沿，各给一拍脉冲
// 思路：din 打一拍得 d1（上一拍的值）；
//       上升沿 = 现在1且上拍0：din & ~d1；下降沿 = ~din & d1
// 关键点：脉冲用寄存器输出（打一拍）时序更干净；
//         若要脉冲与边沿同拍出现，可改为组合 assign
//=====================================================
module edge_detect_ref(input wire clk, input wire rst_n, input wire din,
                       output reg pos_edge, output reg neg_edge);
    reg d1;   // din 的上一拍采样
    // ① 打一拍：记录历史
    always @(posedge clk or negedge rst_n)
        if (!rst_n) d1 <= 1'b0;
        else        d1 <= din;
    // ② 边沿比较 + 脉冲寄存器（每个块只驱动自己的信号，避免多驱动）
    always @(posedge clk or negedge rst_n)
        if (!rst_n) begin
            pos_edge <= 1'b0;
            neg_edge <= 1'b0;
        end
        else begin
            pos_edge <= din & ~d1;    // 0→1 上升沿
            neg_edge <= ~din & d1;    // 1→0 下降沿
        end
endmodule
