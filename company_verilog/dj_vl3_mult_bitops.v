`timescale 1ns/1ns
//=====================================================
// DJ VL3 乘法与位运算（中等）
// 用位运算（移位+加）实现乘法，并给出常用位运算（如统计1的个数）
//=====================================================
module mult_bitops #(parameter W = 4)(
    input  wire [W-1:0]   a,
    input  wire [W-1:0]   b,
    output wire [2*W-1:0] prod,      //a*b（移位加实现）
    output wire [W-1:0]   popcount   //a 中 1 的个数
);
    // TODO: prod 用移位-累加或直接用 *；popcount 逐位累加
    assign prod     = {(2*W){1'b0}};
    assign popcount = {W{1'b0}};
endmodule

//=====================================================
// 范例模块 mult_bitops_ref：参考答案，原模块 mult_bitops 请自行完成
// 题目：移位-加实现乘法；并统计 a 中 1 的个数
// 思路：乘法=对 b 的每一位：为1则把 a<<i 累加进 acc（手工移位加）；
//       popcount=逐位累加 a[i]
// 关键点：部分积左移 i 位前先零扩展到 2W 位防溢出；
//         组合 for 循环会被展开成加法链，可综合
//=====================================================
module mult_bitops_ref #(parameter W = 4)(
    input  wire [W-1:0]   a,
    input  wire [W-1:0]   b,
    output wire [2*W-1:0] prod,
    output wire [W-1:0]   popcount
);
    integer i;                      // 循环变量（综合时展开）
    reg [2*W-1:0] acc;              // 累加器
    reg [W-1:0]   cnt;              // 1 的个数计数
    // 移位-加乘法
    always @(*) begin
        acc = {(2*W){1'b0}};
        for (i = 0; i < W; i = i + 1)
            if (b[i])
                acc = acc + ({{W{1'b0}}, a} << i);  // 部分积 = a<<i
    end
    assign prod = acc;
    // popcount：逐位累加
    always @(*) begin
        cnt = {W{1'b0}};
        for (i = 0; i < W; i = i + 1)
            cnt = cnt + a[i];
    end
    assign popcount = cnt;
endmodule
