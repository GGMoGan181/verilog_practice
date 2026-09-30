`timescale 1ns/1ns
//=====================================================
// VL51 可置位计数器
// load 有效时装入 seed；否则 en 时递增计数
//=====================================================
module loadable_counter #(parameter N = 8)(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        load,       //同步置数
    input  wire        en,
    input  wire [N-1:0] seed,      //置数值
    output reg  [N-1:0] cnt
);
    // TODO: load 优先 cnt<=seed，否则 en 时 cnt<=cnt+1
    always @(*) cnt = {N{1'b0}};
endmodule

//=====================================================
// 范例模块 loadable_counter_ref：参考答案（供对照学习），原模块请自行完成
// 题目：可置位计数器——load 有效时装入 seed（优先），否则 en 时递增
// 思路：单一时序块，优先级：复位 > 同步置数 load > 计数使能 en > 保持
// 关键点：① load 与 en 同拍时 load 优先（if-else 链顺序即优先级）；② 置数后从
//         seed 继续计数；③ 同步置数只在时钟沿生效
//=====================================================
module loadable_counter_ref #(parameter N = 8)(
    input  wire         clk,
    input  wire         rst_n,
    input  wire         load,
    input  wire         en,
    input  wire [N-1:0] seed,
    output reg  [N-1:0] cnt
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= {N{1'b0}};   // 异步复位：优先级最高
        else if (load)
            cnt <= seed;        // 同步置数：优先于计数
        else if (en)
            cnt <= cnt + 1'b1;  // 使能计数（自然溢出回卷）
        // 否则：不写 cnt，寄存器默认保持
    end
endmodule
