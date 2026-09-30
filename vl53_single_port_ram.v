`timescale 1ns/1ns
//=====================================================
// VL53 单端口RAM
// 同一地址端口读写：clk 上升沿写使能时写入，否则读出（同步读）
//=====================================================
module single_port_ram #(parameter DW = 8, AW = 6)(
    input  wire         clk,
    input  wire         rst_n,
    input  wire [AW-1:0] addr,
    input  wire         wr_en,
    input  wire [DW-1:0] wdata,
    output reg  [DW-1:0] rdata
);
    // TODO: reg [DW-1:0] mem [0:2**AW-1]；posedge 写/读
    always @(*) rdata = {DW{1'b0}};
endmodule

//=====================================================
// 范例模块 single_port_ram_ref：参考答案（供对照学习），原模块请自行完成
// 题目：单端口 RAM——同一地址端口，wr_en=1 写入，否则同步读出
// 思路：reg 二维数组即存储器，单一时钟沿内写优先、否则读
// 关键点：① 同步读：rdata 比 addr 晚一拍有效；② 同地址同拍读写时本例写优先
//         （也可设计成读旧值，即 write-first / read-first 两种风格）；③ 复位不清 mem
//         （存储器阵列一般不复位，只复位输出寄存器）
//=====================================================
module single_port_ram_ref #(parameter DW = 8, AW = 6)(
    input  wire          clk,
    input  wire          rst_n,
    input  wire [AW-1:0] addr,
    input  wire          wr_en,
    input  wire [DW-1:0] wdata,
    output reg  [DW-1:0] rdata
);
    reg [DW-1:0] mem [0:2**AW-1];   // 存储阵列：2^AW 个 DW 位单元

    always @(posedge clk) begin
        if (wr_en)
            mem[addr] <= wdata;     // 写使能：写入当前地址
        else
            rdata <= mem[addr];     // 否则：同步读出（晚一拍有效）
    end

    // 输出寄存器复位（mem 内容不复位，综合映射为 Block RAM）
    always @(negedge rst_n) begin
        if (!rst_n)
            rdata <= {DW{1'b0}};
    end
endmodule
