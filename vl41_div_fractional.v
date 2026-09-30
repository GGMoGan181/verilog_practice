`timescale 1ns/1ns
//=====================================================
// VL41 任意小数分频
// 实现非整数分频比（如 2.5、3.75）：常用相位累加/脉冲吞吐法
//=====================================================
module div_fractional #(parameter NUM = 5, DEN = 2)(  // 分频比 = NUM/DEN
    input  wire clk,
    input  wire rst_n,
    output reg  clk_out
);
    // TODO: 累加器每拍加 DEN，溢出/比较决定本拍是否计为有效沿，平均比=NUM/DEN
    always @(*) clk_out = 1'b0;
endmodule

//=====================================================
// 范例模块 div_fractional_ref：参考答案（供对照学习），原模块请自行完成
// 题目：小数分频（分频比 NUM/DEN，如 5/2=2.5）：每 NUM 个 clk 周期内产生 DEN 个输出周期
// 思路：相位累加/吞吁法——累加器每拍加 DEN，累加值跨过 NUM/2、NUM 门槛时翻转输出，
//       越过 NUM 后回卷，长期平均分频比 = NUM/DEN
// 关键点：① 占空比近似而非精确 50%（脉冲分布不均）；② 要 50% 占空比可用
//       双相位波形或/合并；③ 累加器位宽需容纳 NUM+DEN
//=====================================================
module div_fractional_ref #(parameter NUM = 5, DEN = 2)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_out
);
    localparam AW = $clog2(NUM + DEN) + 1;   // 累加器位宽
    reg [AW-1:0] acc;                        // 相位累加器

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            acc     <= {AW{1'b0}};
            clk_out <= 1'b0;
        end
        else begin
            if (acc + DEN >= NUM) begin
                acc <= acc + DEN - NUM;      // 越过一个完整输出周期：回卷
            end
            else if (acc + DEN >= (NUM + 1) / 2) begin
                acc <= acc + DEN;            // 跨过半周期门槛：本拍翻转输出
                clk_out <= ~clk_out;
            end
            else begin
                acc <= acc + DEN;            // 未达门槛：仅累加
            end
        end
    end
endmodule
