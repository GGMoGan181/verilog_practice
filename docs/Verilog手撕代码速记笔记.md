# Verilog 手撕代码速记笔记

> 提炼自 verilog_intro（45 题）、company_verilog（18 题）、verilog_practice（47 题）。
> 面向笔试/面试手撕代码，每条都是"题目 → 套路 → 模板"，可直接背。

---

## 目录

1. [语法保命要点](#一语法保命要点)
2. [组合逻辑五大件](#二组合逻辑五大件)
3. [触发器与边沿检测](#三触发器与边沿检测)
4. [计数器与分频全家桶](#四计数器与分频全家桶)
5. [状态机 FSM](#五状态机-fsm)
6. [序列检测](#六序列检测)
7. [跨时钟域 CDC](#七跨时钟域-cdc)
8. [FIFO](#八fifo)
9. [数据搬运算法](#九数据搬运算法)
10. [手撕常用小技巧](#十手撕常用小技巧)
11. [易错点检查清单](#十一易错点检查清单)

---

## 一、语法保命要点

| 规则 | 一句话记忆 |
|---|---|
| wire vs reg | assign 驱动用 wire；always 内赋值用 reg；**输出端口在 always 里就写 `output reg`** |
| 单驱动纪律 | **一个 reg 只能被一个 always 块驱动**，复位分支只复位本块信号 |
| 阻塞 vs 非阻塞 | 组合逻辑 `always @(*)` 用 `=`；时序逻辑 `always @(posedge)` 用 `<=` |
| 防锁存器 | 组合 always 里 case/if **所有分支赋全值**，或开头给默认值；case 必带 default |
| 位宽 | 相加/相乘前先看位宽：a+b 结果要 +1 位防溢出；截断从高位丢 |
| 复位模板 | `always @(posedge clk or negedge rst_n)` + `if(!rst_n)`，低有效异步复位 |
| 参数化 | `#(parameter N=8)`，位宽写 `[N-1:0]`，计数上限用 `$clog2(N)` |

**运算符速记：**

```verilog
{a,b}      // 拼接：拼位宽、拼移位（{a,1'b0}=a*2）
{N{1'b0}}  // 复制：N 位全 0
^data      // 归约异或：奇偶校验（奇数个1 → 1）
&data      // 归约与：是否全 1
|data      // 归约或：是否非全 0
a >>> 1    // 算术右移（有符号补符号位）；>> 逻辑右移补 0
```

**优先级坑：** `&` `|` `^` 优先级**低于** `==`，写 `assign c = (a==b) & d;` 必须加括号！

---

## 二、组合逻辑五大件

### 1. MUX 多路选择器（三种写法都要会）

```verilog
// 写法① 三目嵌套（最常用）
assign y = (sel==2'b00) ? a : (sel==2'b01) ? b : (sel==2'b10) ? c : d;

// 写法② case（always @(*) + reg）
always @(*) case(sel) 2'b00:y=a; 2'b01:y=b; 2'b10:y=c; default:y=d; endcase

// 写法③ 位选（1bit 多路神器）：d 拼成向量后按 sel 取位
assign y = d[sel];              // 2选1
assign y = {d0,d1,d2,d3}[sel];  // 4选1
```

> 256 选 1 不写 256 个分支：**位选 `assign out = in[sel];`** 一行搞定。

### 2. 译码器（最小项之或）

```verilog
// 3-8 译码：独热码 = 1 左移地址位
assign out = 8'b1 << {a, b, bin};   // 也可写 1<<addr
// 通用写法：out[i] = (addr==i)
```

### 3. 优先编码器（if-else 链 / casex）

```verilog
// 低位优先：casex 自上而下天然实现优先级
always @(*) casex(in)
    8'bxxxxxxx1: out = 3'd0;   // in[0] 最高优先
    8'bxxxxxx10: out = 3'd1;
    ...
    default:     out = 3'd7;
endcase
// 级联扩展：16-4 = 两个 8-3 + 判高位组是否有效
```

### 4. 比较器

```verilog
assign gt = (a > b);          // 直接内建运算符
assign eq = (a == b);
assign lt = ~gt & ~eq;        // 复用结果省逻辑
// 门级展开（题目要求时）：从高位到低位逐位 (a[i]>b[i]) | (相等 & 下一位比较)
```

### 5. 加法器三兄弟

```verilog
// ① 全加器：一位
assign sum = a ^ b ^ cin;
assign cout = (a & b) | (cin & (a ^ b));

// ② 行波进位：N 个全加器串联（generate for 例化），延迟 O(N)

// ③ 超前进位 CLA：进位并行展开，延迟 O(1)（背 g/p 两个公式）
g[i] = a[i] & b[i];   // 生成
p[i] = a[i] ^ b[i];   // 传递
c[i] = g[i] | (p[i] & c[i-1]);
// 展开：c1=g1|p1g0|p1p0c0 ...  每级只有 2~3 级门延迟
s[i] = p[i] ^ c[i-1];
```

**校验类：** 奇校验 `assign p = ~(^data);` 偶校验 `assign p = ^data;`（1 的个数为奇 → ^data=1）。

---

## 三、触发器与边沿检测

### D 触发器（一切时序的原子）

```verilog
always @(posedge clk or negedge rst_n)
    if (!rst_n) q <= 1'b0;
    else        q <= d;
```

### T 触发器（二分频）

```verilog
always @(posedge clk or negedge rst_n)
    if (!rst_n)      q <= 1'b0;
    else if (t)      q <= ~q;    // t=1 翻转；不写 else 默认保持
```

### 边沿检测（打一拍 + 比较）★高频考点

```verilog
reg d_d1;   // d 打一拍
always @(posedge clk or negedge rst_n)
    if (!rst_n) d_d1 <= 1'b0;
    else        d_d1 <= d;

assign pos = d & ~d_d1;   // 上升沿：现在1、过去0
assign neg = ~d & d_d1;   // 下降沿
assign any = d ^ d_d1;    // 双沿（任意跳变）
```

> 口诀：**"打一拍，看新旧"**。脉冲展宽/计数、按键消抖都基于它。

### 异步复位同步释放 ★高频考点

```verilog
reg r1, r2;
always @(posedge clk or negedge rst_n)
    if (!rst_n) begin r1 <= 1'b0; r2 <= 1'b0; end
    else        begin r1 <= 1'b1; r2 <= r1;  end
assign rst_sync_n = r2;   // 复位沿异步生效，释放沿被 clk 同步，防恢复违例
```

---

## 四、计数器与分频全家桶

### 1. 偶数分频（天然 50%）

```verilog
// 计数 0 ~ N/2-1，计满翻转
if (cnt == N/2-1) begin cnt <= 0; clk_out <= ~clk_out; end
else cnt <= cnt + 1'b1;
```

### 2. 奇数分频·不要求占空比

```verilog
// 计数 0 ~ N-1，计满翻转 → 周期 N，占空比 (N±1)/2 : N
if (cnt == N-1) begin cnt <= 0; clk_out <= ~clk_out; end
```

### 3. 奇数分频·50% 占空比（双沿合并）★★必背

```verilog
// 上升沿计数 → clk_p；下降沿计数（同规则）→ clk_n；相或得 50%
always @(posedge clk ...) clk_p <= (cnt_p < (N+1)/2);   // 前 (N+1)/2 拍高
always @(negedge clk ...) clk_n <= (cnt_n < (N+1)/2);   // 相位差半拍
assign clk_out = clk_p | clk_n;
```

> 口诀：**"上升一路、下降一路、两路相或"**。

### 4. 小数分频（相位累加法）

```verilog
// 分频比 NUM/DEN：累加器每拍 +DEN，跨过 NUM/2 门槛翻转输出，超 NUM 回卷
// 长期平均 = NUM/DEN；占空比近似非精确
if (acc+DEN >= NUM)        acc <= acc+DEN-NUM;
else if (acc+DEN >= NUM/2) begin acc <= acc+DEN; clk_out <= ~clk_out; end
else                       acc <= acc+DEN;
```

### 5. 特殊计数器

```verilog
// 格雷码计数：内部二进制 + 输出转换（别直接对格雷码递推）
assign gray = bin ^ (bin >> 1);          // 二进制→格雷
// 格雷→二进制：bin[i] = ^gray[N-1:i]（高位起累积异或）

// 约翰逊（扭环）：末位取反回首位，2N 个状态
q <= {~q[0], q[N-1:1]};

// 环形：独热移位，N 个状态
q <= {q[0], q[N-1:1]};

// 可置位计数器优先级：复位 > load > en > 保持
if(!rst_n) cnt<=0; else if(load) cnt<=seed; else if(en) cnt<=cnt+1;

// 加减计数：cnt <= up_down ? cnt+1 : cnt-1;（N 位自然回卷）

// BCD 计数：逢 10 进位不是逢 16！
if(ones==9) begin ones<=0; tens<= (tens==9)?0:tens+1; end else ones<=ones+1;
```

### 6. 门控时钟切换（无毛刺）

```verilog
// 两个时钟各自 negedge 打拍 + 交叉互锁使能，再相与/相或输出
// 关键：在低电平期间切换选择，避免毛刺；en 交叉互锁防同时导通
```

---

## 五、状态机 FSM

### 三段式模板（工程推荐，直接背骨架）

```verilog
localparam IDLE=2'd0, S1=2'd1, S2=2'd2;
reg [1:0] cur_state, nxt_state;

// ① 时序：只存状态
always @(posedge clk or negedge rst_n)
    if (!rst_n) cur_state <= IDLE;
    else        cur_state <= nxt_state;

// ② 组合：只算次态
always @(*) begin
    case (cur_state)
        IDLE:    nxt_state = cond ? S1 : IDLE;
        S1:      nxt_state = ...;
        default: nxt_state = IDLE;   // 必写，防跑飞
    endcase
end

// ③ 输出：组合（Moore 看现态 / Mealy 看现态+输入）或时序（打一拍无毛刺）
always @(*) match = (cur_state == S_HIT);        // Moore
always @(*) match = (cur_state==S2) && (a==0);   // Mealy
```

### 二段式 = ①+② 合并输出到组合块（次态和输出写在同一个 always @(*)）。

**选型口诀：** 三段式清晰好维护；输出需无毛刺 → 第三段改时序；代码量敏感 → 二段式。

---

## 六、序列检测

### 方法一：移位窗口法（定长序列最快）

```verilog
reg [7:0] win;
always @(posedge clk ...) win <= {win[6:0], a};      // 左移入位，先到在高位
assign match = (win == 8'b0111_0001);                 // 整体比较
// 带不关心位：分段比较，如 011XXX110 → win[8:6]==011 && win[2:0]==110
```

### 方法二：FSM 法（带门控/复杂协议必用）

- 状态 = **已匹配前缀长度**（S0 空、S1 匹配 1 位…）
- 失配时跳"**最长可用后缀**"对应状态（KMP 思想），不要一律回 IDLE
- **重叠** vs **非重叠**唯一区别：命中态的出边
  - 非重叠：命中 → 无条件回 IDLE
  - 重叠：命中后按输入跳到后缀状态（如 0110 命中后来 1 → "01" → S2）
- `data_valid` 门控：次态逻辑最外层 `if(!data_valid) nxt = cur;`（无效拍自环保持）
- Moore 输出 `match=(cur==S4)` 命中维持一拍；Mealy 输出当拍即中（快一拍）

### 方法三：计数法（分组不重叠检测，如每 6 位查 011100）

- 计数器分组 + 组内比较，计满回零重新分组（组边界固定 → 天然不重叠）
- ⚠ 比较时机：在 `cnt==5`（末位到达那拍）用 `{data_reg[4:0], data}` 拼出完整 6 位再比较；
  直接比 `data_reg` 会缺当前输入位 → 漏检

---

## 七、跨时钟域 CDC

> 总原则：**单 bit 打两拍；多 bit 用格雷码/握手/异步 FIFO；脉冲用 toggle。**

### 1. 电平信号：两级同步器（必背）

```verilog
reg s1, s2;
always @(posedge clk_dst) begin s1 <= sig_src; s2 <= s1; end
// s2 即同步后信号；打两拍是为了把亚稳态概率压到可忽略
```

### 2. 脉冲信号：toggle 法（快→慢必用）★★

```verilog
// 源域：脉冲翻转电平
always @(posedge src_clk) if (pulse_in) toggle <= ~toggle;
// 目的域：两级同步 + 异或检边沿还原脉冲
always @(posedge dst_clk) begin s1<=toggle; s2<=s1; s3<=s2; pulse_out<=s2^s3; end
```

> 限制：两次脉冲间隔 > 目的域 3 拍，否则翻转抵消丢脉冲。

### 3. 多 bit 数据：握手 / MUX 同步器

```
源域：din_valid → 锁存 hold_reg（数据保持稳定）→ 拉 req
目的域：req 打两拍 → 采 hold_reg → 拉 ack
源域：ack 打两拍 → 撤 req（四相握手完成一次传输）
```

> 为什么不能直接打两拍：多 bit 各自采样时刻可能不同 → 拼出错误中间值。

### 4. 高速连续流：异步 FIFO（格雷码指针），见下节。

---

## 八、FIFO

### 同步 FIFO（计数法，单时钟）

```verilog
wire wr_ok = wr_en && !full;    // 满禁写
wire rd_ok = rd_en && !empty;   // 空禁读
// 单一 always：写 mem[wptr]、读 mem[rptr]，指针环状回卷
// 存量：cnt <= cnt + wr_ok - rd_ok;（同拍读写自动抵消）
full  <= (cnt+wr_ok-rd_ok == DEPTH);
empty <= (cnt+wr_ok-rd_ok == 0);
```

### 异步 FIFO（格雷码指针，双时钟）★★★ 面试大题

四个组成部分，按顺序写不会乱：

1. **双口 RAM**：写口 wr_clk、读口 rd_clk 各一个 always
2. **读写指针**：各多 1 位（回卷区分满/空）；`gray = (bin>>1) ^ bin`
3. **两级同步**：对方指针打两拍进本域（格雷码每次只变 1 位，采样安全）
4. **满空判断**：
   ```verilog
   // 满：写格雷码追上读格雷码一圈 → 高两位相反、其余相同
   assign full  = (wr_gray == {~rd_gray_s2[AW:AW-1], rd_gray_s2[AW-2:0]});
   // 空：读格雷码 == 同步来的写格雷码
   assign empty = (rd_gray == wr_gray_s2);
   ```

> 满空判断偏保守（同步延迟只会"误报"不会"漏报"）→ 安全。

---

## 九、数据搬运算法

### 1. 串并转换

```verilog
// 串→并：左移入位（先到在高位）+ 计数
shift <= {shift[6:0], din};
if (cnt==7) begin dout <= {shift[6:0],din}; dout_valid<=1; cnt<=0; end
// 并→串：右移出位（高位先发）+ 计数
always @(posedge clk) if (load) shift <= din; else shift <= {shift[6:0],1'b0};
assign dout = shift[7];   // 或先 load 拍输出 shift[7]
```

### 2. 位宽转换

| 类型 | 套路 |
|---|---|
| 整数倍（8→16） | 暂存高字节 + flag，第二拍拼 `{hi, din}` 输出 |
| 扩展（1→N） | 大缓冲 buf + 比特计数 bits：每拍左移入新数据，bits≥N 取高 N 位输出，余位左移 N 位对齐、bits-=N |
| 收缩（N→1） | 攒 N 拍拼一次输出（计数器控制拼接位置） |

> 通用口诀：**"左移入、攒够出、余位对齐"**；先到数据永远在高位。

### 3. 大小端 / 位序转换

```verilog
assign out = {data[0],data[1],...,data[7]};        // 拼接反序
// 或 generate for：assign out[i] = data[N-1-i];
// 或 function 内 for 循环（可复用）
```

### 4. 乘法（移位加）

```verilog
{a,1'b0} = a*2    {a,2'b00} = a*4    a<<n = a*2^n
3a = a + {a,1'b0}        // 移位 + 加法组合，比乘法器省资源
// 流水线乘法：输入打拍 → 乘积打拍 → 输出，valid 逐级同步流动
```

---

## 十、手撕常用小技巧

```verilog
// 1. 独热码互斥判断
assign hit = |(sel & mask);

// 2. 判 2 的幂 / 取最低位的 1
assign low1 = a & (~a + 1'b1);

// 3. 计数到任意值 M：位宽 $clog2(M)，条件 cnt == M-1 回卷

// 4. 使能保持：if(en) q <= d;  ← 不写 else，寄存器默认保持，最省代码

// 5. 输出脉冲一拍：先默认 valid<=0，再在条件里置 1（时序块内）

// 6. generate for：批量例化/批量位操作，块要命名 begin:gen_x

// 7. function：组合逻辑复用（位反序、编码），只能有 input、返回值单一

// 8. 中间 reg 转 wire 输出：assign out = out_reg;（端口是 wire 时）
```

**ROM/查表题：** `always @(*) case(addr) 0:y=...; ... endcase` 就是 ROM。

**信号发生器题：** 计数器当时基 + case 选波形（方波=计数比较翻转、锯齿=计数值直出、三角=方向 flag 双边界翻转）。

---

## 十一、易错点检查清单（交卷前 30 秒过一遍）

- [ ] reg 有没有被**两个 always 块驱动**？（最常见硬伤）
- [ ] 复位分支复位的是**本块自己的信号**吗？（别复位到别块的）
- [ ] 组合 always 里 case 有没有 **default**？if 有没有 else？（防锁存器）
- [ ] 时序块用 `<=`、组合块用 `=`，没混用吧？
- [ ] 位宽够吗？加法 +1 位、乘法 A+B 位、计数上限回卷
- [ ] `&|^` 和 `==` 连用时**加括号**了吗？
- [ ] 有符号运算：符号位扩展 `{a[7],a}`，声明 `signed`
- [ ] 端口方向/类型：always 里赋值的输出要 `output reg`
- [ ] FSM：default 回 IDLE；状态位宽装得下所有状态
- [ ] 跨时钟域：单 bit 打两拍了吗？多 bit 没直接打拍吧？
- [ ] 题目要求的信号名（如 testbench 层次引用的变量）**拼写一致**
      （血泪教训：`reg dada_in_reg;` ≠ `data_in_reg`，编译直接报找不到变量）

---

## 附：三大题型万能模板索引

| 题型 | 模板 | 见章节 |
|---|---|---|
| 分频 | 偶数单沿翻转 / 奇数双沿相或 / 小数相位累加 | 四 |
| 序列检测 | 移位窗口比较 / FSM 前缀状态机 | 六 |
| FIFO | 同步计数法 / 异步格雷码指针法 | 八 |
| CDC | 电平打两拍 / 脉冲 toggle / 多bit握手 | 七 |
| 位宽转换 | 大缓冲 + 比特计数 | 九 |
| FSM | 三段式骨架 + Moore/Mealy 输出 | 五 |
