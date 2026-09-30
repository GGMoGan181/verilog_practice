`timescale 1ns/1ns
//超前四位进位加法器

module lac_4(
    input [3:0]a,
    input [3:0]b,
    input c_1,
    output wire [3:0]s,
    output wire c0
    );

    wire [3:0]g;
    wire [3:0]p;
    wire [3:0]c;
    genvar i;
    generate for(i=0;i<4; i=i+1)
        begin : gen_i
           assign g[i]=a[i] & b[i];
           assign p[i]=a[i] ^ b[i];

        end  
    endgenerate

    assign c[0]=g[0] | p[0] & c_1;
    assign c[1]=g[1] | p[1] & c[0];
    assign c[2]=g[2] | p[2] & c[1];
    assign c[3]=g[3] | p[3] & c[2];
    //注意这里要用 |  运算
    assign c0=c[3];
    
    assign s[0]= p[0] ^ c_1;
    assign s[1]= p[1] ^ c[0];
    assign s[2]= p[2] ^ c[1];
    assign s[3]= p[3] ^ c[2];

endmodule

//=====================================================
// 范例模块 lac_4_ref：参考答案（供对照学习），原模块 lac_4 请自行完成
// 题目：4 位超前进位加法器（CLA），输入 a/b/低位进位 c_1，输出和 s 与进位 c0
// 思路：定义 g[i]=a[i]&b[i]（本位产生进位）、p[i]=a[i]^b[i]（本位传递进位），
//       把进位链完全展开成仅依赖 g/p/c_1 的并行表达式，消除逐位等待（行波）延迟
// 关键点：① c[i]=g[i] | p[i]&c[i-1]；② 展开后每一级进位都只有 2~3 级门延迟；
//         ③ 求和 s[i]=p[i]^c[i-1]
//=====================================================
module lac_4_ref(
    input  [3:0] a,
    input  [3:0] b,
    input        c_1,     // 最低位进位输入
    output [3:0] s,       // 4 位和
    output       c0       // 最高位进位输出
);
    wire [3:0] g;   // 生成信号：本位两个 1 必产生进位
    wire [3:0] p;   // 传递信号：本位恰有一个 1 时，进位由低位决定
    wire [3:0] c;   // 各位进位（c[i] 为第 i 位向第 i+1 位的进位）

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : gen_gp
            assign g[i] = a[i] & b[i];
            assign p[i] = a[i] ^ b[i];
        end
    endgenerate

    // 进位并行展开：每级都只用 g/p/c_1 表示，不再逐级串行传递
    assign c[0] = g[0] | (p[0] & c_1);
    assign c[1] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c_1);
    assign c[2] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c_1);
    assign c[3] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1])
                | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & c_1);

    assign c0 = c[3];              // 最高位进位输出

    // 求和：本位异或 = 传递信号异或输入进位
    assign s[0] = p[0] ^ c_1;
    assign s[1] = p[1] ^ c[0];
    assign s[2] = p[2] ^ c[1];
    assign s[3] = p[3] ^ c[2];
endmodule