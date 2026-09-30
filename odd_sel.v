`timescale 1ns/1ps

//单目运算
//a=&d  是否全是1
//a=^d  奇偶校验
//a=|d  是否全为0

module odd_sel(
    input  [31:0] data,
    input         sel,
    output        cheak
);
    wire cheak_temp;
    assign cheak_temp=^data;
    assign cheak=sel ?cheak_temp : ~cheak_temp;
    
    
endmodule

//=====================================================
// 范例模块 odd_sel_ref：参考答案（供对照学习），原模块 odd_sel 请自行完成
// 题目：可切换奇偶校验——sel=1 输出奇校验位（^data），sel=0 输出偶校验位（取反）
// 思路：归约异或 ^data 统计 1 的个数奇偶：奇数个 1 时结果为 1
// 关键点：① 归约运算符 &/|/^ 是单目运算：&data 全 1 判、|data 非全 0 判、^data 奇偶判；
//         ② 纯组合逻辑，assign 一行完成
//=====================================================
module odd_sel_ref(
    input  [31:0] data,
    input         sel,     // 1：奇校验；0：偶校验
    output        cheak
);
    wire parity = ^data;             // 归约异或：data 中 1 的个数为奇数时 = 1
    assign cheak = sel ? parity : ~parity;   // 三目运算选择奇/偶校验输出
endmodule