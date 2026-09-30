`timescale 1ns/1ns
//=====================================================
// A里 VL4 求最小公倍数（中等）
// 硬件迭代求 LCM(a,b)：常用 LCM = a*b / GCD(a,b)，GCD 用辗转相减/相除迭代
//=====================================================
module lcm(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        start,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg         done,
    output reg  [15:0] lcm_val
);
    // TODO: FSM 迭代求 GCD（相减/模除），再 lcm=a*b/gcd；done 拉高
    always @(*) begin done = 1'b0; lcm_val = 16'b0; end
endmodule

//=====================================================
// 范例模块 lcm_ref：参考答案，原模块 lcm 请自行完成
// 题目：硬件迭代求 LCM(a,b) = a*b / GCD(a,b)，GCD 用辗转相减
// 思路：FSM 三段：IDLE 等 start 并锁存 a,b 与乘积；
//       CALC 辗转相减直到 x==y（此时 x 即 GCD）；
//       FIN 算 lcm=product/gcd 并拉 done 一拍
// 关键点：迭代每拍只做一次减法（硬件化循环）；
//         a 或 b 为 0 时 LCM=0，需单独短路处理防死循环
//=====================================================
module lcm_ref(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        start,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg         done,
    output reg  [15:0] lcm_val
);
    localparam IDLE = 2'd0, CALC = 2'd1, FIN = 2'd2;
    reg [1:0]  state;
    reg [7:0]  x, y;          // 辗转相减工作寄存器
    reg [15:0] product;       // a*b 锁存
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;  x <= 8'd0; y <= 8'd0;
            product <= 16'd0; done <= 1'b0; lcm_val <= 16'd0;
        end
        else case (state)
            IDLE: begin
                done <= 1'b0;
                if (start) begin
                    product <= a * b;             // 锁存乘积
                    if (a == 8'd0 || b == 8'd0) begin
                        lcm_val <= 16'd0;         // 0 的 LCM 为 0，短路
                        done    <= 1'b1;
                    end
                    else begin
                        x <= a; y <= b; state <= CALC;
                    end
                end
            end
            CALC: begin
                if (x == y)      state <= FIN;    // 相等即 GCD
                else if (x > y)  x <= x - y;      // 大者减小者
                else             y <= y - x;
            end
            FIN: begin
                lcm_val <= product / x;           // LCM = a*b / GCD
                done    <= 1'b1;                  // 完成脉冲
                state   <= IDLE;
            end
            default: state <= IDLE;
        endcase
    end
endmodule
