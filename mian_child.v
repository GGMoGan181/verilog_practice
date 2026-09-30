`timescale 1ns/1ns
module child_mod(
    input [7:0]data_a,
    input [7:0]data_b,
    input clk,rst_n,
    output [7:0] out
);
    reg [7:0] out_reg;
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            out_reg<=0;
        end
        else begin
            if(data_a>=data_b) begin
                
                out_reg<=data_a;
            end
            else begin
                out_reg<=data_b;
            end
        end
    end
    assign out=out_reg;
endmodule

module main_mod(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input clk,rst_n,
    output [7:0] d
);
    wire [7:0] out1;
    child_mod child1(
        .data_a(a),
        .data_b(b),
        .clk(clk),
        .rst_n(rst_n),
        .out(out1)
    );

    wire[ 7:0] out2;
    child_mod child2(
        .data_a(b),
        .data_b(c),
        .clk(clk),
        .rst_n(rst_n),
        .out(out2)
    );

    wire[ 7:0] out3;
    child_mod child3(
        .data_a(out1),
        .data_b(out2),
        .clk(clk),
        .rst_n(rst_n),
        .out(out3)
    );
    assign d=out3;
    //例化格式
    //原模块名  新名字（
    //   .原端口名（现在的信号名），

    //)；


    // wire [7:0] out1;
    // wire [7:0] out2;
    // child_mod u1(
    //     .data_a(a),
    //     .data_b(b),
    //     .clk(clk),
    //     .rst_n(rst_n),
    //     .out(out1)
    // );

    // child_mod u2(
    //     .data_a(out1),
    //     .data_b(c),
    //     .clk(clk),
    //     .rst_n(rst_n),
    //     .out(out2)
    // );

    // always @(posedge clk or negedge rst_n) begin
    //     if(!rst_n) begin
    //         d<=0;
    //     end
    //     else begin
    //         d<=out2;
    //     end
    // end
endmodule

//=====================================================
// 范例：参考答案（供对照学习），原模块 child_mod/main_mod 请自行完成
// 题目：子模块求两数最大值（寄存输出），主模块例化子模块求 a/b/c 三数最大值
// 思路：两两比较——先 max(a,b) 与 max(b,c)，再对两个中间结果求 max；
//       也可以先 max(a,b) 再 max(中间结果,c)（两级串行，延迟多一拍）
// 关键点：① 例化格式：模块名 实例名(.端口(信号), ...)；② 子模块内部时序输出，
//         主模块纯结构连接；③ 三例化并行方案总延迟 2 拍，串行方案 2 拍但复用同一逻辑
//=====================================================
module child_mod_ref(                 // 子模块：寄存输出 max(data_a, data_b)
    input  [7:0] data_a,
    input  [7:0] data_b,
    input        clk,
    input        rst_n,
    output [7:0] out
);
    reg [7:0] out_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            out_reg <= 8'd0;                       // 异步复位清零
        else
            out_reg <= (data_a >= data_b) ? data_a : data_b;   // 三目选大
    end
    assign out = out_reg;
endmodule

module main_mod_ref(                  // 主模块：例化三个子模块求三数最大值
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input        clk,
    input        rst_n,
    output [7:0] d
);
    wire [7:0] ab_max;   // max(a,b)，第 1 拍结果
    wire [7:0] bc_max;   // max(b,c)，第 1 拍结果

    // 第一级：两个子模块并行比较（同一时钟拍完成）
    child_mod_ref u_ab (
        .data_a (a),
        .data_b (b),
        .clk    (clk),
        .rst_n  (rst_n),
        .out    (ab_max)
    );

    child_mod_ref u_bc (
        .data_a (b),
        .data_b (c),
        .clk    (clk),
        .rst_n  (rst_n),
        .out    (bc_max)
    );

    // 第二级：对两个中间结果再求最大，得到三数最大值（第 2 拍输出）
    child_mod_ref u_final (
        .data_a (ab_max),
        .data_b (bc_max),
        .clk    (clk),
        .rst_n  (rst_n),
        .out    (d)
    );
endmodule