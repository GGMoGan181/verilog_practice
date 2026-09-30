`timescale 1ns/1ns
//=====================================================
// VL52 加减计数器
// up_down=1 递增，up_down=0 递减；en 使能
//=====================================================
module updown_counter #(parameter N = 8)(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        en,
    input  wire        up_down,    //1=加,0=减
    output reg  [N-1:0] cnt
);
    // TODO: en 时按 up_down 加1或减1
    always @(*) cnt = {N{1'b0}};
endmodule

//=====================================================
// 范例模块 updown_counter_ref：参考答案（供对照学习），原模块请自行完成
// 题目：加减计数器——en 有效时 up_down=1 递增、up_down=0 递减
// 思路：单一时序块，en 使能 + up_down 选择加/减方向
// 关键点：① N 位无符号自然回卷：减到 0 再减变全 1，加到全 1 再加变 0；
//         ② en=0 时保持；③ 复位清零
//=====================================================
module updown_counter_ref #(parameter N = 8)(
    input  wire         clk,
    input  wire         rst_n,
    input  wire         en,
    input  wire         up_down,   // 1=加，0=减
    output reg  [N-1:0] cnt
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= {N{1'b0}};                  // 异步复位清零
        else if (en)
            cnt <= up_down ? cnt + 1'b1        // 使能时按方向加/减
                           : cnt - 1'b1;       // （N 位自然回卷）
        // en=0：不写 cnt，默认保持
    end
endmodule
