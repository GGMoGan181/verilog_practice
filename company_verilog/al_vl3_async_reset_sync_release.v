`timescale 1ns/1ns
//=====================================================
// A里 VL3 异步复位同步释放（较难）
// 复位立即异步生效，但撤销(释放)要在时钟沿同步进行，避免恢复/移除时间违例
//=====================================================
module async_reset_sync_release(
    input  wire clk,
    input  wire rst_n_in,     //外部异步复位(低有效)
    output wire rst_n_out     //同步释放后的复位(低有效)
);
    // TODO: 两级触发器链：rst_n_in 异步清零两级FF，释放时逐级同步置1
    assign rst_n_out = 1'b1;
endmodule

//=====================================================
// 范例模块 async_reset_sync_release_ref：参考答案，原模块 async_reset_sync_release 请自行完成
// 题目：异步复位同步释放：复位立即生效，撤销时跟时钟沿同步
// 思路：两级 FF 都用 rst_n_in 异步清零：
//       复位一来 r1/r2 立刻=0（异步生效）；
//       复位撤销后 r1 在第一个时钟沿置1，r2 在第二个沿才跟1（同步释放）
// 关键点：敏感列表是 posedge clk or negedge rst_n_in；
//         释放路径经过两级 FF，避免恢复/移除时间违例与亚稳态
//=====================================================
module async_reset_sync_release_ref(
    input  wire clk,
    input  wire rst_n_in,
    output wire rst_n_out
);
    reg r1, r2;   // 两级同步链
    always @(posedge clk or negedge rst_n_in)
        if (!rst_n_in) begin   // 异步清零：复位立即生效
            r1 <= 1'b0;
            r2 <= 1'b0;
        end
        else begin             // 释放时逐级同步置1
            r1 <= 1'b1;
            r2 <= r1;
        end
    assign rst_n_out = r2;     // 第二级输出：比复位撤销晚两拍释放
endmodule
