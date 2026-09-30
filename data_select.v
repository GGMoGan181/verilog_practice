`timescale 1ns/1ns
//有符号数，最高位1表示负数，0表示正数
module data_select(
    input clk,rst_n,
    input signed [7:0]a,
    input signed [7:0]b,
    input [1:0]select,
    output reg signed [8:0]out
    );
    always @(posedge clk or negedge rst_n)begin
        if(!rst_n) begin
            out<=0;
        end
        else begin
            case(select)
                2'b00:begin 
                    out<={a[7],a};
                end
                2'b01:begin
                    out<={b[7],b};
                end
                2'b10:begin
                    out<={a[7],a}+{b[7],b};
                end
                2'b11:begin
                    out<={a[7],a}-{b[7],b};
                end
                default:begin
                    out<=9'b0;
                end
            endcase
        end
    end
endmodule

//=====================================================
// 范例模块 data_select_ref：参考答案（供对照学习），原模块 data_select 请自行完成
// 题目：有符号数运算选择器——select=00 输出 a、01 输出 b、10 输出 a+b、11 输出 a-b，
//       结果位宽 9 位（容纳溢出），时序输出
// 思路：8 位有符号数符号位扩展到 9 位（{a[7],a}）后再运算，保证正负号正确
// 关键点：① signed 声明让比较/加法按有符号处理；② 单一 always 块驱动 out，复位清零
//=====================================================
module data_select_ref(
    input  wire        clk,
    input  wire        rst_n,
    input  wire signed [7:0] a,
    input  wire signed [7:0] b,
    input  wire [1:0]  select,
    output reg  signed [8:0] out
);
    // 符号位扩展：8 位 -> 9 位，数值不变（正数补 0，负数补 1）
    wire signed [8:0] a_ext = {a[7], a};
    wire signed [8:0] b_ext = {b[7], b};

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            out <= 9'sd0;              // 异步复位清零
        else begin
            case (select)
                2'b00:   out <= a_ext;         // 直传 a
                2'b01:   out <= b_ext;         // 直传 b
                2'b10:   out <= a_ext + b_ext; // 加法（9 位不会溢出）
                2'b11:   out <= a_ext - b_ext; // 减法
                default: out <= 9'sd0;
            endcase
        end
    end
endmodule