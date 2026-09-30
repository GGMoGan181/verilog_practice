`timescale 1ns/1ns
//=====================================================
// VL29 信号发生器
// 用计数器产生周期性信号（方波/周期脉冲），周期可参数化
//=====================================================
module signal_generator(
	input clk,
	input rst_n,
	input [1:0] wave_choise,
	output reg [4:0]wave
	);
	reg [4:0] cnt;
	reg flag;
    always@(posedge clk or negedge rst_n) begin
		if(!rst_n) begin 
            cnt<=1'b0;
            flag<=1'b0;
        end 
        else begin 
            cnt<= wave_choise!=0? 0:
                                cnt==19? 0: cnt+1;
            flag<= wave_choise!=2? 0 :
                                wave ==0 ? 1:
                                    wave ==19? 0: flag;
        end
	always@(posedge clk or negedge rst_n) begin
		case(wave_choise)
            0: wave<= cnt<9? 20:0;
            1: wave<= cnt<19? wave+1 :0;
            2: wave<= flag ? wave+1: wave-1;
        endcase
	end
  
endmodule

//=====================================================
// 范例模块 signal_generator_ref：参考答案（供对照学习），原模块请自行修正完成
// 题目：波形发生器——wave_choise=0 方波、1 锯齿波、2 三角波（幅值 0~19，周期 20 拍）
// 思路：① 方波/锯齿波共用 0~19 自由计数器；② 三角波需方向标志 flag：
//       递增到 19 后翻转为递减，减到 0 后再翻转（双边界检测）
// 关键点：① 原模块隐患——第一个 always 块缺 end（块未闭合即嵌套第二个 always，语法错误）；
//         ② 每个 reg 只由一个 always 块驱动；③ 复位分支只复位本块信号
//=====================================================
module signal_generator_ref(
    input  wire       clk,
    input  wire       rst_n,
    input  wire [1:0] wave_choise,   // 0:方波 1:锯齿波 2:三角波
    output reg  [4:0] wave
);
    reg [4:0] cnt;    // 0~19 循环计数器（方波/锯齿波用）
    reg       flag;   // 三角波方向标志：1=递增，0=递减

    // 块1：只驱动 cnt/flag——基础时基与三角波方向控制
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt  <= 5'd0;
            flag <= 1'b1;              // 复位后默认递增方向
        end
        else begin
            cnt <= (cnt == 5'd19) ? 5'd0 : cnt + 1'b1;   // 0~19 自由循环
            // 三角波到顶/到底翻转方向
            if (wave == 5'd19)
                flag <= 1'b0;          // 到顶：转为递减
            else if (wave == 5'd0)
                flag <= 1'b1;          // 到底：转为递增
        end
    end

    // 块2：只驱动 wave——按波形选择输出
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            wave <= 5'd0;
        else begin
            case (wave_choise)
                2'd0: wave <= (cnt < 5'd10) ? 5'd20 : 5'd0;  // 方波：半周期高半周期低
                2'd1: wave <= cnt;                            // 锯齿波：0~19 循环递增
                2'd2: wave <= flag ?                          // 三角波：按方向增减
                            ((wave == 5'd19) ? wave : wave + 1'b1) :
                            ((wave == 5'd0)  ? wave : wave - 1'b1);
                default: wave <= 5'd0;
            endcase
        end
    end
endmodule
