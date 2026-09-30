`timescale 1ns/1ns
//=====================================================
// VL38 自动贩售机1
// 简单 FSM：投币累计到售价后出货（不找零/单一币种示例）
//=====================================================
module vending_machine1(
    input  wire clk,
    input  wire rst_n,
    input  wire coin,       //每次投入一枚硬币
    output reg  goods       //出货指示
);
    // TODO: 状态=已投金额；达到售价输出 goods 并回初始态
    always @(*) goods = 1'b0;
endmodule

//=====================================================
// 范例模块 vending_machine1_ref：参考答案（供对照学习），原模块请自行完成
// 题目：简单贩售机——每拍 coin=1 投入 1 元，累计满 3 元出货（goods 拉高一拍）并清零
// 思路：状态即已投金额（计数器充当状态），计满自动归零
// 关键点：① goods 用寄存器输出，仅在计满那一拍拉高；② 不找零：恰好计满即出货
//=====================================================
module vending_machine1_ref(
    input  wire clk,
    input  wire rst_n,
    input  wire coin,        // 每拍一枚 1 元硬币
    output reg  goods
);
    localparam PRICE = 3;              // 售价：3 元
    reg [1:0] money;                   // 已投金额（状态）

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            money <= 2'd0;
            goods <= 1'b0;
        end
        else begin
            goods <= 1'b0;                          // 默认不出货，仅计满那拍拉高
            if (coin) begin
                if (money == PRICE - 1) begin       // 本枚硬币投入后恰好满价
                    goods <= 1'b1;                  // 出货一拍
                    money <= 2'd0;                  // 金额清零，开始新一轮
                end
                else
                    money <= money + 1'b1;          // 未满：继续累计
            end
        end
    end
endmodule
