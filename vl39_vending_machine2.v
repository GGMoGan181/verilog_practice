`timescale 1ns/1ns
//=====================================================
// VL39 自动贩售机2
// 进阶 FSM：多币种投币、达到售价出货并对超额部分找零
//=====================================================
module vending_machine2(
    input  wire       clk,
    input  wire       rst_n,
    input  wire [1:0] coin,    //币种编码（如 0=无,1=0.5,2=1,3=2 元）
    output reg        goods,   //出货指示
    output reg        change   //找零指示
);
    // TODO: 状态=累计金额；>=售价出货，超额部分产生 change
    always @(*) begin goods = 1'b0; change = 1'b0; end
endmodule

//=====================================================
// 范例模块 vending_machine2_ref：参考答案（供对照学习），原模块请自行完成
// 题目：多币种贩售机——coin: 0=无币 1=0.5元 2=1元 3=2元；售价 2 元（以 0.5 元为单位计 4），
//       投满出货 goods，若投入后超额则同时找零 change，金额扣除售价后继续累计
// 思路：状态=累计金额（以 0.5 元为单位）；每拍加上币值，>=售价则出货并减去售价
// 关键点：① 金额单位化避免小数；② 超额找零：change 与 goods 同拍拉高；
//         ③ 余额保留（money-PRICE）继续参与下一轮累计
//=====================================================
module vending_machine2_ref(
    input  wire       clk,
    input  wire       rst_n,
    input  wire [1:0] coin,     // 0=无币 1=0.5元 2=1元 3=2元
    output reg        goods,
    output reg        change
);
    localparam PRICE = 4;        // 售价 2 元 = 4 个 0.5 元单位
    reg [2:0] money;             // 累计金额（0.5 元单位）

    // 币值译码：编码 -> 实际金额（单位 0.5 元）
    reg [2:0] coin_val;
    always @(*) begin
        case (coin)
            2'd1:    coin_val = 3'd1;   // 0.5 元
            2'd2:    coin_val = 3'd2;   // 1 元
            2'd3:    coin_val = 3'd4;   // 2 元
            default: coin_val = 3'd0;   // 无币
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            money  <= 3'd0;
            goods  <= 1'b0;
            change <= 1'b0;
        end
        else begin
            goods  <= 1'b0;                        // 默认不出货
            change <= 1'b0;                        // 默认不找零
            if (coin_val != 0) begin
                if (money + coin_val >= PRICE) begin   // 投入后达到/超过售价
                    goods  <= 1'b1;                    // 出货一拍
                    change <= (money + coin_val > PRICE); // 严格超额才找零
                    money  <= money + coin_val - PRICE; // 扣除售价，余额继续累计
                end
                else
                    money <= money + coin_val;         // 未满：继续累计
            end
        end
    end
endmodule
