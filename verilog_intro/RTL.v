`timescale 1ns/1ns
//=====================================================
// 根据 RTL 图编写 Verilog 程序：DFF(data_in_reg) + 上升沿比较逻辑
//   RTL 图结构：data_in 经一个 D 触发器打一拍得 data_in_reg；
//   比较逻辑 data_in & ~data_in_reg 再经一个 D 触发器输出 data_out
//   （即检测 data_in 上升沿，data_out 给一拍脉冲）
// 注意：官网 testbench(main.v) 会用层次路径引用内部信号 data_in_reg，
//       所以该寄存器名字必须叫 data_in_reg，不能改名/写错！
//=====================================================
module RTL(
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);
    // TODO: 请自行完成：
    //   1) reg data_in_reg; 打一拍寄存器（名字必须一致）
    //   2) 上升沿比较：data_in && !data_in_reg 寄存器输出到 data_out
    //
    // 你上一次的尝试（保留备查）：声明写成了 reg dada_in_reg;（拼写错误），
    // 导致模块内根本没有 data_in_reg 这个变量，testbench 层次引用报：
    //   main.v: error: Could not find variable ``data_in_reg'' in ``RTL''
    // 且当时文件缺少 module/endmodule 外壳。
    //   always@(posedge clk or negedge rst_n) begin
    //       if(!rst_n) data_in_reg <= 1'b0;
    //       else       data_in_reg <= data_in;
    //   end
    //   always@(posedge clk or negedge rst_n) begin
    //       if(!rst_n)                  data_out <= 1'b0;
    //       else if(data_in && !data_in_reg) data_out <= 1'b1;
    //       else                        data_out <= 1'b0;
    //   end
endmodule

//=====================================================
// 范例模块 RTL_ref：参考答案（供对照学习），原模块 RTL 请自行完成
// 题目：按 RTL 图实现：data_in 打一拍得 data_in_reg，
//       用 data_in & ~data_in_reg 检测上升沿，寄存器输出 data_out
// 思路：两个 D 触发器：第一级存历史值，第二级存边沿比较结果；
//       比较逻辑是组合的，但输出经过 FF，故 data_out 是干净的一拍脉冲
// 关键点：① 内部寄存器命名 data_in_reg 与 testbench 层次引用保持一致；
//         ② 两个 always 块各驱动自己的寄存器，避免多驱动冲突；
//         ③ 异步低复位：negedge rst_n 进敏感列表且复位分支优先
//=====================================================
module RTL_ref(
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);
    reg data_in_reg;   // 第一级 DFF：data_in 的上一拍采样（名字不可改）

    // ① 打一拍寄存器
    always @(posedge clk or negedge rst_n)
        if (!rst_n) data_in_reg <= 1'b0;
        else        data_in_reg <= data_in;

    // ② 上升沿比较 + 输出寄存器
    always @(posedge clk or negedge rst_n)
        if (!rst_n)                      data_out <= 1'b0;
        else if (data_in && !data_in_reg) data_out <= 1'b1;   // 现1且上拍0 = 上升沿
        else                             data_out <= 1'b0;   // 其余时刻清0
endmodule
