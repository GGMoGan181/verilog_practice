`timescale 1ns/1ns
//============================================================
// 序列检测器（移位寄存器法）
// 功能：检测串行输入 a 中是否出现 8 位序列 01110001，命中时 match=1
// 原理：每拍把 a 移入 a_temp 最低位（右移）；a_temp[7] 为最旧位、
//       a_temp[0] 为最新位；当整个 a_temp == 8'b01110001 时，
//       说明最近 8 位输入正好构成目标序列
//============================================================
module sequence_detect(
	input clk,        //时钟
	input rst_n,      //低电平异步复位
	input a,          //串行输入，每拍 1 位
	output reg match  //序列命中指示
	);
    reg [7:0] a_temp; //8 位移位窗口，保存最近 8 位输入

	//块1：移位——每拍把新输入 a 移入窗口最低位
	always@(posedge clk or negedge rst_n)
    begin
       if(rst_n==0) 
        begin
            
            match<=0;   //⚠ 复位的是 match，而非本块驱动的 a_temp：
                        //  导致 a_temp 上电为 x；且 match 被块1和块2双重驱动（多驱动冲突）
        end
       else 
        begin
            a_temp<={a_temp[6:0],a};  //右移一位：a 进入 bit0，最高位 bit7 被移出
        end
    end

    //块2：比较——窗口整体等于目标序列时拉高 match
    always @(posedge clk or negedge  rst_n)
    begin
        if(rst_n==0)
            begin match<=0;   //复位清零
            end
        else if(a_temp==8'b01110001)  //最近 8 位命中目标序列 01110001
            begin 
                match<=1;
            end
        else
            begin
                match<=0;   //未命中则清零
            end  
        

    end    

            


    
  
endmodule

//=====================================================
// 范例模块 sequence_detect_ref：参考答案（供对照学习），原模块请自行修正完成
// 题目：检测串行输入中的 8 位序列 01110001，命中时 match=1（允许重叠）
// 思路：移位窗口法——每拍把 a 移入 8 位寄存器，窗口整体等于目标序列即命中
// 关键点：① 原模块的隐患——match 被两个 always 块双重驱动（多驱动冲突），
//         且块 1 复位分支误写 match 而非 a_temp；② 修正：每个 reg 只由一个块驱动，
//         复位分支只复位本块信号；③ 比较可用组合输出，命中后 match 仅维持一拍
//=====================================================
module sequence_detect_ref(
    input  wire clk,
    input  wire rst_n,
    input  wire a,          // 串行输入，每拍 1 位
    output reg  match
);
    reg [7:0] a_temp;       // 8 位移位窗口：bit0 最新、bit7 最旧

    // 块1：只驱动 a_temp（复位分支也只复位 a_temp，避免多驱动）
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_temp <= 8'b0;                    // 复位清空窗口（原模块误写为 match）
        else
            a_temp <= {a_temp[6:0], a};        // 右移：新位进 bit0，bit7 移出
    end

    // 块2：只驱动 match——窗口命中目标序列时拉高一拍
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            match <= 1'b0;
        else
            match <= (a_temp == 8'b01110001);  // 逐拍比较，允许重叠检测
    end
endmodule
