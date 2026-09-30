`timescale 1ns/1ns
// 组合逻辑 VL1 4位数值比较器：输出 gt / eq / lt
module cmp4(input wire [3:0] a, input wire [3:0] b,
            output wire gt, output wire eq, output wire lt);
    assign gt = 1'b0;   // TODO: a>b
    assign eq = 1'b0;   // TODO: a==b
    assign lt = 1'b0;   // TODO: a<b
endmodule

//=====================================================
// 范例模块 cmp4_ref：参考答案（供对照学习），原模块 cmp4 请自行完成
// 题目：4bit 数值比较器，输出 gt/eq/lt 三个指示
// 思路：无符号数直接用关系运算符，一行一个输出
// 关键点：三个输出互斥且必居其一；== 是相等而非赋值 =
//=====================================================
module cmp4_ref(input wire [3:0] a, input wire [3:0] b,
                output wire gt, output wire eq, output wire lt);
    assign gt = (a >  b);   // a 大于 b
    assign eq = (a == b);   // 相等
    assign lt = (a <  b);   // a 小于 b
endmodule
