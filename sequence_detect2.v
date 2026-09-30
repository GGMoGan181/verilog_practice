`timescale 1ns/1ns
//============================================================
// 序列检测器：检测 9 位序列 011XXX110
//   （前 3 位 = 011，后 3 位 = 110，中间 3 位 XXX 不关心）
// 思路：a_temp 保存最近 9 位输入
//   match_b = (最高 3 位 a_temp[8:6] == 011)  // 前 3 位命中
//   match_f = (最低 3 位 a_temp[2:0] == 110)  // 后 3 位命中
//   match   = match_f && match_b              // 前后都命中即整段命中
//============================================================
module sequence_detect(
	input clk,        //时钟
	input rst_n,      //低电平异步复位
	input a,          //串行输入，每拍 1 位
	output reg match  //序列命中指示
	);
    reg [8:0] a_temp;      //9 位移位窗口，保存最近 9 位输入
    reg match_f,match_b;   //match_b:前3位011命中标志；match_f:后3位110命中标志

    //块1：移位——每拍把 a 移入窗口最低位；复位时清空窗口
    always@(posedge clk or negedge rst_n)
        begin 
            if(rst_n==0) a_temp<=9'b0;       //复位：清空窗口
            else a_temp<={a_temp[7:0],a};    //右移一位：a 进入 bit0，bit8 被移出

        end

    //块2：判断"前 3 位是否为 011"
    always@(posedge clk or negedge rst_n)

        begin 
            if(rst_n==0) match_b<=0;         //复位清零 match_b
            else if(a_temp[8:6]==3'b011)     //窗口最高 3 位 == 011
                begin
                    match_b<=1;              //前 3 位命中
                end
            else match_f<=0;   //⚠ 本意应是 match_b<=0（未命中时清除前3位标志），
                               //  却写成 match_f：使 match_b 命中后无法清零，
                               //  且 match_f 被本块与块3同时驱动（多驱动冲突）
        end

    //块3：判断"后 3 位是否为 110"
    always@(posedge clk or negedge rst_n)
        begin 
            if(rst_n==0) match_f<=0;         //复位清零 match_f
            else if(a_temp[2:0]==3'b110)     //窗口最低 3 位 == 110
                begin
                    match_f<=1;              //后 3 位命中
                end
            else match_f<=0;                 //未命中则清零 match_f
        end

    //块4：组合输出——前 3 位与后 3 位都命中时 match=1
    always @(*) match = match_f && match_b;
    
    
endmodule

//=====================================================
// 范例模块 sequence_detect2_ref：参考答案（供对照学习），原模块请自行修正完成
// 题目：检测 9 位序列 011XXX110（前 3 位 011、后 3 位 110、中间 3 位不关心）
// 思路：9 位移位窗口，同时比较窗口高 3 位与低 3 位，两段都命中即 match=1
// 关键点：① 原模块的隐患——块 2 未命中分支误写 match_f<=0（应为 match_b<=0），
//         造成 match_b 无法清零 + match_f 被两块双重驱动；② 修正后每个 reg 单一驱动，
//         比较用组合逻辑一拍完成，无需中间寄存器
//=====================================================
module sequence_detect2_ref(
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output wire match
);
    reg [8:0] a_temp;   // 9 位移位窗口：bit0 最新、bit8 最旧

    // 时序块：只驱动 a_temp
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_temp <= 9'b0;                // 复位清空窗口
        else
            a_temp <= {a_temp[7:0], a};    // 右移一位，新输入进 bit0
    end

    // 组合比较：最旧 3 位（窗口高位）==011 且最新 3 位==110，中间 3 位不关心
    // 注意：比较用的是"上一拍窗口"，故 match 比末位输入晚一拍拉高
    assign match = (a_temp[8:6] == 3'b011) && (a_temp[2:0] == 3'b110);
endmodule
