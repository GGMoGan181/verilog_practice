`timescale 1ns/1ps
module mux4_1(
    input  [1:0] a,
    input  [1:0] b,
    input  [1:0] c,
    input  [1:0] d,
    input  [1:0] sel,
    output [1:0] mux_out
);
    reg [1:0]mux_out_reg;
    always@(*) begin
    
        case(sel)
        2'b00:mux_out_reg=a;
        2'b01 :mux_out_reg=b;
        2'b10:mux_out_reg=c;
        2'b11:mux_out_reg=d;
        default:mux_out_reg=2'b00;
        endcase


    end
    assign mux_out=mux_out_reg;

endmodule

//=====================================================
// 范例模块 mux4_1_ref：参考答案（供对照学习），原模块 mux4_1 请自行完成
// 题目：4 选 1 多路选择器，sel 选择 a/b/c/d 之一输出（位宽 2）
// 思路：组合逻辑三选一写法——case / 条件运算符 / 位选，任选其一即可
// 关键点：always @(*) 内所有分支都要赋值，避免产生锁存器
//=====================================================
module mux4_1_ref(
    input  [1:0] a,
    input  [1:0] b,
    input  [1:0] c,
    input  [1:0] d,
    input  [1:0] sel,
    output [1:0] mux_out
);
    // 写法一：嵌套三目运算符（纯组合、无中间 reg，最简洁）
    assign mux_out = (sel == 2'b00) ? a :
                     (sel == 2'b01) ? b :
                     (sel == 2'b10) ? c : d;

    // 写法二：case 语句（与写法一等价，二选一即可，此处注释保留供对照）
    // reg [1:0] mux_out_reg;
    // always @(*) begin
    //     case (sel)
    //         2'b00: mux_out_reg = a;
    //         2'b01: mux_out_reg = b;
    //         2'b10: mux_out_reg = c;
    //         2'b11: mux_out_reg = d;
    //     endcase
    // end
    // assign mux_out = mux_out_reg;
endmodule