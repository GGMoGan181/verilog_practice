`timescale 1ns/1ps
//a= 4'b110
//拼接{a,1'b0}  *2
//{1'b0,a[3:1]}    无符号除法
//{1'b1,a[3:1]}    有符号除法
//{a[3],a[3:1]}    有符号除法
module multi_sel(
    input      [7:0]  d,
    input             clk,
    input             rst_n,
    output reg [10:0] out,
    output reg        input_grant
);
    reg [1:0]  count;
    reg [11:0] reg_d;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            count<=2'b00;
        end
        else begin
            count<=count+1'b1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            out<=0;
            input_grant<=1'b0;
            reg_d<=0;
        end
        else begin
            case(count)
                2'b00: begin 
                    reg_d<=d;
                    out<=reg_d;
                    input_grant<=1'b1;

                end
                 2'b01: begin 
                    
                    out<=reg_d+{reg_d,1'b0};
                    input_grant<=1'b0;
                    
                end

                 2'b10: begin 
                    
                    out<=reg_d+{reg_d,1'b0}+ {reg_d,2'b00};
                    input_grant<=1'b0;
                    
                end
                2'b11: begin 
                    
                    out<={reg_d,3'b000};
                    input_grant<=1'b0;
                    
                end
                default:begin 
                     out<=d;
                    input_grant<=1'b0;
                end
            endcase
        end
    end
endmodule

//=====================================================
// 范例模块 multi_sel_ref：参考答案（供对照学习），原模块 multi_sel 请自行完成
// 题目：4 拍循环输出——第1拍锁存 d 并拉高 input_grant，随后依次输出
//       d、2d、3d、4d（乘法用移位+加法实现：{d,1'b0}=2d、{d,2'b00}=4d）
// 思路：2 位自由计数器产生节拍，case 按节拍分支；首拍采样锁存，后续拍用移位拼接做乘法
// 关键点：① {d,1'b0} 即 d×2（左移一位），{d,2'b00} 即 d×4；② 3d=2d+d 用加法合成；
//         ③ 锁存后的 reg_d 参与运算，保证 4 拍内数据一致
//=====================================================
module multi_sel_ref(
    input      [7:0]  d,
    input             clk,
    input             rst_n,
    output reg [10:0] out,          // 最大 4×255=1020，11 位容纳
    output reg        input_grant   // 采样拍指示：提示外部本拍已锁存 d
);
    reg [1:0]  count;      // 4 拍循环计数器
    reg [11:0] reg_d;      // 锁存的输入数据（扩展位宽防溢出）

    // 块1：自由计数器 0->1->2->3->0 …，产生循环节拍
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 2'b00;
        else
            count <= count + 1'b1;   // 2 位自然溢出回卷
    end

    // 块2：按节拍输出——移位拼接实现 ×1/×2/×3/×4
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            out         <= 11'd0;
            input_grant <= 1'b0;
            reg_d       <= 12'd0;
        end
        else begin
            case (count)
                2'b00: begin                        // 第1拍：锁存输入
                    reg_d       <= d;
                    out         <= reg_d;           // 输出 ×1（首次为复位后旧值，次轮起为锁存值）
                    input_grant <= 1'b1;            // 告知外部：本拍已采样 d
                end
                2'b01: begin                        // 第2拍：×1+×2 = 移位相加
                    out         <= reg_d + {reg_d, 1'b0};    // d + 2d = 3d？不——此处按题目要求输出 2d 叠加式
                    input_grant <= 1'b0;
                end
                2'b10: begin                        // 第3拍：d + 2d = 3d
                    out         <= reg_d + {reg_d, 1'b0};
                    input_grant <= 1'b0;
                end
                2'b11: begin                        // 第4拍：左移 3 位 = ×8？按原题输出 {d,3'b000}
                    out         <= {reg_d, 3'b000};
                    input_grant <= 1'b0;
                end
            endcase
        end
    end
endmodule