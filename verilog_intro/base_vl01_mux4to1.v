`timescale 1ns/1ns
// 基础语法 VL1 四选一多路器：2bit sel 从 4 路输入选 1
module mux4to1(input wire [3:0] d, input wire [1:0] sel, output wire y);
    assign y = 1'b0;   // TODO: assign y = d[sel]; 或 case
endmodule

//=====================================================
// 范例模块 mux4to1_ref：参考答案（供对照学习），原模块 mux4to1 请自行完成
// 题目：2bit 选择信号 sel 从 4 路输入 d[3:0] 中选出 1 路输出
// 思路：sel 的数值恰好就是要选的下标，直接用"位选" d[sel] 最简洁
// 关键点：位选/case/嵌套三运算符三种写法等价，任选其一
//=====================================================
module mux4to1_ref(input wire [3:0] d, input wire [1:0] sel, output wire y);
    assign y = d[sel];   // 位选：sel=0 取 d[0]，sel=3 取 d[3]
    // 等价写法1（case）：
    //   reg t; always @(*) case(sel)
    //       2'd0: t=d[0]; 2'd1: t=d[1]; 2'd2: t=d[2]; default: t=d[3];
    //   endcase
    // 等价写法2（嵌套三目）：
    //   y = (sel==2'd0) ? d[0] : (sel==2'd1) ? d[1] : (sel==2'd2) ? d[2] : d[3];
endmodule
