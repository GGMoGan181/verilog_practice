`timescale 1ns/1ns
module data_sel(
    input [15:0]data ,
    input [1:0] sel,
    input clk,rst_n,
    output [15:0]out,
    output reg valid_out

);
    reg [15:0]d_reg;
    reg [15:0]out_reg;
    wire [3:0]d0;
    wire [3:0]d1;
    wire [3:0]d2;
    wire [3:0]d3;
    assign d0=data[3:0];
    assign d1=data[7:4];
    assign d2=data[11:8];
    assign d3=data[15:12];
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            d_reg<=0;
            valid_out<=1'b0;
            out_reg<=0;
        end
        else begin
            d_reg<=data;
            case(sel)
                2'b00:begin
                    out_reg<=d0;
                    valid_out<=1'b0;
                end
                2'b01:begin
                    out_reg<=d0+d1;
                    valid_out<=1'b1;
                end
                2'b10:begin
                    out_reg<=d0+d1;
                    valid_out<=1'b1;
                end
                2'b11:begin
                    out_reg<=d0+d2;
                    valid_out<=1'b1;
                end
                default:begin
                    out_reg<=0;
                    valid_out<=1'b0;
                end
            endcase
        end

    end

    assign out=out_reg;
    

endmodule

//=====================================================
// 范例模块 data_sel_ref：参考答案（供对照学习），原模块 data_sel 请自行完成
// 题目：16 位数据切成 4 段（d0=低4位 … d3=高4位），按 sel 选择运算并寄存输出：
//       sel=00 输出 d0、sel=01 输出 d0+d1、sel=10 输出 d0+d1、sel=11 输出 d0+d2，
//       除 sel=00 外 valid_out=1（输出晚输入一拍）
// 思路：先切片，再在单一时序 always 块内按 sel 分支寄存结果
// 关键点：① 4 位相加前先零扩展到 16 位，避免位宽截断；② 复位时 out/valid 同时清零
//=====================================================
module data_sel_ref(
    input  wire [15:0] data,
    input  wire [1:0]  sel,
    input  wire        clk,
    input  wire        rst_n,
    output wire [15:0] out,
    output reg         valid_out
);
    // 四个 4 位切片：d0 为最低 4 位，d3 为最高 4 位
    wire [3:0] d0 = data[3:0];
    wire [3:0] d1 = data[7:4];
    wire [3:0] d2 = data[11:8];
    wire [3:0] d3 = data[15:12];   // 本题未用到，保留完整性

    reg [15:0] out_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            out_reg   <= 16'd0;    // 复位：结果清零
            valid_out <= 1'b0;     // 复位：无效指示
        end
        else begin
            case (sel)
                2'b00: begin out_reg <= d0;                  valid_out <= 1'b0; end
                2'b01: begin out_reg <= d0 + d1;             valid_out <= 1'b1; end
                2'b10: begin out_reg <= d0 + d1;             valid_out <= 1'b1; end
                2'b11: begin out_reg <= d0 + d2;             valid_out <= 1'b1; end
                default: begin out_reg <= 16'd0;             valid_out <= 1'b0; end
            endcase
        end
    end

    assign out = out_reg;   // 寄存器输出接到端口
endmodule