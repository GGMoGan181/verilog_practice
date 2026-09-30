`timescale 1ns/1ns
//四位数值比较器
module comparator_4(
    input [3:0]a,
    input [3:0]b,
    output wire y0,
    output wire y1,
    output wire y2

);
    //y2: a>b   y1: a==b   y0: a<b
    assign y2=(a[3]>b[3])
            | ((a[3]==b[3]) & (a[2]>b[2]))
            | ((a[3]==b[3]) & (a[2]==b[2]) & (a[1]>b[1]))
            | ((a[3]==b[3]) & (a[2]==b[2]) & (a[1]==b[1]) & (a[0]>b[0]));
    assign y1=(a[3]==b[3]) & (a[2]==b[2]) & (a[1]==b[1]) & (a[0]==b[0]);
    assign y0=(~y2) & (~y1);

endmodule

//=====================================================
// 范例模块 comparator_4_ref：参考答案（供对照学习），原模块 comparator_4 请自行完成
// 题目：4 位数值比较器，y2=(a>b)、y1=(a==b)、y0=(a<b)
// 思路：Verilog 内建关系运算符综合后即为比较器，直接使用最简洁；
//       若要求门级展开，则从高位到低位逐位比较（原模块即展开写法）
// 关键点：三个输出互斥，y0 可用 ~y2 & ~y1 复用结果，减少逻辑
//=====================================================
module comparator_4_ref(
    input  [3:0] a,
    input  [3:0] b,
    output wire  y0,   // a < b
    output wire  y1,   // a == b
    output wire  y2    // a > b
);
    assign y2 = (a > b);    // 内建比较运算符，可综合
    assign y1 = (a == b);
    assign y0 = (a < b);    // 等价写法：assign y0 = ~y2 & ~y1;
endmodule