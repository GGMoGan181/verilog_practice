`timescale 1ns/1ns
// 基础语法 VL9 子模块实现三输入数的大小比较：底层比较子模块+顶层例化
module cmp2(input wire [3:0] x, input wire [3:0] y, output wire gt);
    assign gt = (x > y);   // 子模块：两数比较
endmodule

module compare3(input wire [3:0] a, input wire [3:0] b, input wire [3:0] c,
                output wire [3:0] maxv);
    // TODO: 例化 cmp2 逐级比较求三数最大
    assign maxv = 4'b0;
endmodule

//=====================================================
// 范例模块 compare3_ref：参考答案（供对照学习），原模块 compare3 请自行完成
// 题目：复用题目给出的 cmp2 子模块，逐级比较求 a、b、c 三数最大
// 思路：第一轮 cmp2 比 a、b 得 ab_max；第二轮 cmp2 比 ab_max、c 得最终最大
// 关键点：例化时端口用 .名字(信号) 连接；子模块 cmp2 直接复用本文件已有的
//=====================================================
module compare3_ref(input wire [3:0] a, input wire [3:0] b, input wire [3:0] c,
                    output wire [3:0] maxv);
    wire       gt_ab;      // 第一轮比较结果：a>b?
    wire       gt_mc;      // 第二轮比较结果：ab_max>c?
    wire [3:0] ab_max;     // a、b 中的较大者
    cmp2 u_cmp_ab (.x(a),    .y(b),    .gt(gt_ab));   // 第一轮：比 a、b
    assign ab_max = gt_ab ? a : b;                     // 选出 a、b 较大者
    cmp2 u_cmp_mc (.x(ab_max), .y(c), .gt(gt_mc));     // 第二轮：与 c 比
    assign maxv = gt_mc ? ab_max : c;                  // 两轮胜者即三数最大
endmodule
