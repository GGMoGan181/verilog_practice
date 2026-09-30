`timescale 1ns/1ns
//=====================================================
// VL54 RAM的简单实现
// 用最简方式实现存储阵列（可读可写），理解 reg 数组即存储器
//=====================================================
module ram_simple #(parameter DW = 8, DEPTH = 256)(
    input  wire         clk,
    input  wire         wr_en,
    input  wire [7:0]   addr,
    input  wire [DW-1:0] wdata,
    output reg  [DW-1:0] rdata
);
    // TODO: reg [DW-1:0] mem [0:DEPTH-1]；写使能写、否则读
    always @(*) rdata = {DW{1'b0}};
endmodule

//=====================================================
// 范例模块 ram_simple_ref：参考答案（供对照学习），原模块请自行完成
// 题目：最简 RAM——理解 reg 数组即存储器，写使能写、否则同步读
// 思路：一个 always 块 + 二维 reg 数组，综合工具自动推断为 RAM
// 关键点：① 读地址打一拍输出（同步读）；② 若把读改成 assign 则是异步读
//         （组合逻辑直出，不推荐，难映射 Block RAM）
//=====================================================
module ram_simple_ref #(parameter DW = 8, DEPTH = 256)(
    input  wire          clk,
    input  wire          wr_en,
    input  wire [7:0]    addr,
    input  wire [DW-1:0] wdata,
    output reg  [DW-1:0] rdata
);
    reg [DW-1:0] mem [0:DEPTH-1];   // 存储阵列

    always @(posedge clk) begin
        if (wr_en)
            mem[addr] <= wdata;     // 写：使能时写入
        else
            rdata <= mem[addr];     // 读：同步输出，晚一拍有效
    end
endmodule
