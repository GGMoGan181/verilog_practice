`timescale 1ns/1ns
//=====================================================
// VL56 流水线乘法器
// 把乘法拆成多级寄存器流水（部分积->累加），提高吞吐
//=====================================================
module pipeline_multiplier #(parameter AW = 4, BW = 4)(
    input  wire            clk,
    input  wire            rst_n,
    input  wire [AW-1:0]   a,
    input  wire [BW-1:0]   b,
    input  wire            valid_in,
    output reg  [AW+BW-1:0] prod,
    output reg             valid_out
);
    // TODO: 逐级打拍：stage1 部分积 -> stage2 累加 -> 输出，valid 同步流水
    always @(*) begin prod = {(AW+BW){1'b0}}; valid_out = 1'b0; end
endmodule

//=====================================================
// 范例模块 pipeline_multiplier_ref：参考答案（供对照学习），原模块请自行完成
// 题目：流水线乘法器——输入打拍、乘法打拍、输出打拍，valid 随数据同步流动
// 思路：两级流水——stage1：锁存 a/b；stage2：计算乘积并寄存输出；
//       每拍都能接收新输入（吞吐 1 个/拍），延迟 = 流水级数
// 关键点：① valid 必须和数据同路径同拍数打拍，否则对齐错误；② 拆分乘法为
//       多级可缩短关键路径、提高主频；③ 复位时各级清零
//=====================================================
module pipeline_multiplier_ref #(parameter AW = 4, BW = 4)(
    input  wire             clk,
    input  wire             rst_n,
    input  wire [AW-1:0]    a,
    input  wire [BW-1:0]    b,
    input  wire             valid_in,
    output reg  [AW+BW-1:0] prod,
    output reg              valid_out
);
    reg [AW-1:0]    a_s1, b_s1;   // stage1：输入寄存
    reg             v_s1;         // stage1 的 valid

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_s1      <= {AW{1'b0}};
            b_s1      <= {BW{1'b0}};
            v_s1      <= 1'b0;
            prod      <= {(AW+BW){1'b0}};
            valid_out <= 1'b0;
        end
        else begin
            // stage1：锁存输入（每拍都接收，吞吐不阻塞）
            a_s1 <= a;
            b_s1 <= b;
            v_s1 <= valid_in;
            // stage2：用上一拍锁存的输入计算乘积并寄存输出
            prod      <= a_s1 * b_s1;   // 综合器展开为乘法器，寄存后缩短关键路径
            valid_out <= v_s1;          // valid 与数据同步流动（总延迟 2 拍）
        end
    end
endmodule
