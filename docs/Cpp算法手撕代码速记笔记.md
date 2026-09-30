# C++ 算法手撕代码速记笔记

> 提炼自 cpp_algorithm 目录约 100 道 LeetCode 高频题。
> 每条 = 套路 → 适用题 → 最小模板，语言从简，直接背。

---

## 目录

1. [双指针](#一双指针)
2. [滑动窗口](#二滑动窗口)
3. [哈希表](#三哈希表)
4. [链表](#四链表)
5. [二叉树](#五二叉树)
6. [回溯](#六回溯)
7. [二分查找](#七二分查找)
8. [栈与单调栈](#八栈与单调栈)
9. [堆（优先队列）](#九堆优先队列)
10. [贪心](#十贪心)
11. [动态规划](#十一动态规划)
12. [多维 DP](#十二多维-dp)
13. [BFS / DFS / 图](#十三bfs--dfs--图)
14. [位运算与技巧题](#十四位运算与技巧题)
15. [手写排序](#十五手写排序)
16. [STL 速查](#十六stl-速查)
17. [易错点清单](#十七易错点清单)

---

## 一、双指针

**口诀：同向快慢指针找窗口，相向双指针找配对。**

### 1. 相向双指针（排序数组求配对）

适用：三数之和、盛最多水、接雨水（部分）

```cpp
sort(a.begin(), a.end());
for (i...) {
    int l = i+1, r = n-1;
    while (l < r) {
        int s = a[i]+a[l]+a[r];
        if (s == 0) { 记录; 去重l++,r--; }
        else if (s < 0) l++;
        else r--;
    }
}
// 去重三处：i、l、r 都与前一个相同则跳过
```

### 2. 快慢指针（原地修改数组）

适用：移动零、删除重复项

```cpp
int slow = 0;
for (fast...) if (nums[fast] != 0) swap(nums[slow++], nums[fast]);
```

### 3. 三指针分界（荷兰国旗）

适用：颜色分类 sortColors

```cpp
int p0=0, i=0, p2=n-1;
while (i <= p2) {
    if (a[i]==0) swap(a[i++], a[p0++]);
    else if (a[i]==2) swap(a[i], a[p2--]);  // i 不动！换过来的还没看
    else i++;
}
```

---

## 二、滑动窗口

**口诀：右扩左缩，窗口内维护一个合法状态。**

适用：无重复最长子串、最小覆盖子串、找字母异位词、长度最小子数组

```cpp
unordered_map<char,int> need, window;
int left = 0, right = 0;
while (right < s.size()) {
    char c = s[right++];
    window[c]++;                    // ① 扩：更新窗口状态
    while (窗口不合法) {             // ② 缩：条件触发
        char d = s[left++];
        window[d]--;
    }
    更新答案;                        // ③ 记录（最长在缩前/外，最短在缩内）
}
```

- 求**最长**：while 条件 = 非法，答案在 while 外更新
- 求**最短**：while 条件 = 合法，答案在 while 内更新
- 定长窗口（异位词）：右进左出保持长度 k，比较计数即可

---

## 三、哈希表

**口诀：查"见过没有"用 set，查"值配钥匙"用 map，计数用数组当 map。**

| 题型 | 用法 |
|---|---|
| 两数之和 | `map[值]=下标`，边存边查 `target-x` |
| 字母异位词分组 | key = 排序后的串，`map<string,vector<string>>` |
| 最长连续序列 | 全入 set；只从"无前驱"(`x-1`不在)的数起跳，O(n) |
| 和为 K 的子数组 | 前缀和 + map：查 `preSum-k` 出现次数 |
| 多数元素 | 摩尔投票（见技巧章）或 map 计数 |
| 只出现一次 | 异或（见位运算） |

```cpp
// 前缀和模板（subarraySum）
unordered_map<int,int> cnt{{0,1}};   // 空前缀必须初始化！
int sum=0, ans=0;
for (x : nums) { sum+=x; ans+=cnt[sum-k]; cnt[sum]++; }
```

---

## 四、链表

**口诀：虚拟头结点防丢头，快慢指针找环找中点，递归想清楚"这层干什么"。**

### 1. 反转链表（必背，写不出直接挂）

```cpp
ListNode* pre = nullptr;
while (head) {
    ListNode* nxt = head->next;  // 存
    head->next = pre;            // 反
    pre = head; head = nxt;      // 移
}
return pre;
```

### 2. 快慢指针

```cpp
// 找中点：slow 走一步 fast 走两步，fast 到尾 slow 在中
// 判环：相遇即有环
// 环入口：相遇后一指针回头，同速再走相遇即入口
// 倒数第k：fast 先走 k 步，再同走
```

### 3. 合并类

```cpp
// 合并两个有序链表：哑结点 dummy，尾插法
ListNode dummy(0); ListNode* tail = &dummy;
while (l1 && l2) { 小的接到 tail; tail=tail->next; }
tail->next = l1 ? l1 : l2;
return dummy.next;
// 合并K个：两两合并，或全部入小顶堆
```

### 4. K 个一组翻转

先数够 k 个 → 反转这一段 → 接回前后。**画图，标好 pre/next 四个断点。**

### 5. 深拷贝随机链表

map 存 `原节点→新节点`，第二遍接 next/random；或原地交织复制省空间。

---

## 五、二叉树

**口诀：前序想"构造"，中序想"BST/顺序"，后序想"先要子结果"，层序用队列。**

### 1. 递归三件套（万能框架）

```cpp
int dfs(TreeNode* root) {
    if (!root) return 基础情况;
    左 = dfs(root->left);
    右 = dfs(root->right);
    return 用左右组合出本层答案;
}
```

| 题 | 递归含义 |
|---|---|
| 最大深度 | `1 + max(左深, 右深)` |
| 直径 | 后序：过本点最长 = 左深+右深，全局变量取 max |
| 最大路径和 | 后序：`贡献 = max(0, max(左,右)) + val`，全局 max(左+右+val) |
| 对称/相同 | 双参递归：`f(p,q) = p->val==q->val && f(p左,q右) && f(p右,q左)` |
| 翻转 | `swap(left,right)` 再递归 |
| 验证 BST | 中序遍历严格递增；或递归带上下界 |
| 最近公共祖先 | 后序：左右都找到→本点；否则返回非空那边 |

### 2. 层序遍历模板（BFS）

```cpp
queue<TreeNode*> q; q.push(root);
while (!q.empty()) {
    int n = q.size();               // 关键：先固定本层数量
    for (i<n) { 出队; 处理; 左右孩子入队; }
}
// 变体：右视图=每层最后一个；锯齿=偶数层 reverse
```

### 3. 构造类

- 前+中序建树：前序首元素是根，在中序中定位切左右，递归
- 有序数组建 BST：取中点为根，左右半区递归（天然平衡）
- 展开为链表：前序遍历结果，右链串起来

---

## 六、回溯

**口诀：路径 + 选择列表 + 结束条件；做选择 → 递归 → 撤销选择。**

```cpp
void backtrack(路径, 选择列表) {
    if (满足结束条件) { res.push_back(路径); return; }
    for (选择 : 选择列表) {
        if (不合法/需剪枝) continue;
        做选择;
        backtrack(路径, 新选择列表);
        撤销选择;                    // 回溯的灵魂
    }
}
```

| 题 | 要点 |
|---|---|
| 全排列 | used 数组标记，每层从 0 选 |
| 子集 | 每个节点都是答案，start 控制不回头 |
| 组合总和 | 可重复选：递归传 i 不是 i+1；剪枝 sort 后 break |
| 括号生成 | 左括号数 < n 可加左；右 < 左 可加右 |
| 字母组合 | 每个数字对应字母表，逐位选 |
| 分割回文串 | start 切割，是回文才继续 |
| N 皇后 | 逐行放，检查列/两对角线（`r+c`、`r-c` 判重） |
| 单词搜索 | 网格 DFS + visited 标记回溯 |

**去重（有重复元素的排列/组合）：** 先排序，同层 `if(i>start && a[i]==a[i-1]) continue;`

---

## 七、二分查找

**口诀：闭区间 `[l,r]` 配 `l<=r`；找边界想清楚收缩方向。**

```cpp
// 标准模板（闭区间，背这个）
int l=0, r=n-1;
while (l <= r) {
    int mid = l + (r-l)/2;          // 防溢出写法
    if (a[mid] == t) return mid;
    else if (a[mid] < t) l = mid+1;
    else r = mid-1;
}
return -1;
```

| 题 | 套路 |
|---|---|
| 搜索插入位置 | 标准二分，退出时 l 即答案 |
| 查找首末位置 | 两次二分：找左边界（==时继续缩右）、找右边界 |
| 旋转数组搜索 | mid 与端点比较判断哪半有序，再判 target 在不在有序半区 |
| 旋转数组最小值 | `a[mid] > a[r]` → l=mid+1；否则 r=mid（**不配 <=**，区间收缩模板） |
| 搜索二维矩阵 | 展平成一维二分；或 II 型从右上角走（大左移、小下移） |
| 两数组中位数 | 分割二分：在短数组上二分切割线，使左半全部 ≤ 右半 |
| x 的平方根 | 在答案区间上二分 |

---

## 八、栈与单调栈

**口诀：括号配对用栈；"下一个更大/更小"用单调栈。**

### 1. 括号匹配

```cpp
stack<char> st;
for (c : s) {
    if (左括号) st.push(对应右括号);
    else if (st.empty() || st.top()!=c) return false;
    else st.pop();
}
return st.empty();
```

### 2. 单调栈（找左右第一个更大/更小）

适用：每日温度、下一个更大元素、接雨水、柱状图最大矩形

```cpp
stack<int> st;                       // 存下标！
for (i = 0; i < n; i++) {
    while (!st.empty() && a[i] > a[st.top()]) {   // 找更大→递减栈
        int j = st.top(); st.pop();
        ans[j] = i - j;              // i 就是 j 的"下一个更大"
    }
    st.push(i);
}
```

- 找**下一个更大** → 栈内递减；找**下一个更小** → 栈内递增
- 柱状图最大矩形：对每根柱子找左右第一个更矮（哨兵简化边界）
- 接雨水：按行（横条）算，单调递减栈弹出时结算凹槽

### 3. 其他栈题

- 最小栈：辅助栈同步存当前最小值
- 字符串解码 `3[a2[c]]`：双栈（数字栈+字符串栈），遇 `[` 压，遇 `]` 弹拼
- 最长有效括号：栈底存"最后未匹配下标"，初始压 -1
- 逆波兰：数字压栈，运算符弹两个算完压回

---

## 九、堆（优先队列）

**口诀：第 K 大用小顶堆（堆顶是门槛），第 K 小用大顶堆；频率 Top K 同理。**

```cpp
priority_queue<int, vector<int>, greater<int>> minHeap;  // 小顶堆
for (x : nums) {
    minHeap.push(x);
    if (minHeap.size() > k) minHeap.pop();   // 堆超 k 弹堆顶
}
return minHeap.top();                        // 第 k 大
```

| 题 | 用法 |
|---|---|
| 第K个最大/小 | 大小为 k 的堆；或快速选择 O(n) |
| 前K个高频 | map 计数 + 小顶堆按频率维护 k 个 |
| 数据流中位数 | **对顶堆**：大顶堆存小半、小顶堆存大半，平衡大小差 ≤1 |
| 合并K个链表 | k 个头结点入小顶堆，弹出最小接尾，其 next 入堆 |

---

## 十、贪心

**口诀：每步取局部最优，先想"为什么局部最优能推出全局最优"。**

| 题 | 贪心策略 |
|---|---|
| 买卖股票 | 所有正差价全吃：`sum(max(0, p[i]-p[i-1]))` |
| 跳跃游戏 | 维护最远可达 `maxReach`，i 超过它即失败 |
| 跳跃游戏 II | 到达边界才跳一次，边界=当前一步能到的最远处 |
| 划分字母区间 | 记录每字母最后位置，到达当前段最远 last 即切 |
| 分发饼干 | 双排序，小饼干先喂小胃口 |

---

## 十一、动态规划

**口诀：定义状态 → 写转移 → 定初始 → 定顺序。想不出就手推前几项。**

### 1. 一维 DP

```cpp
// 爬楼梯/斐波那契：dp[i]=dp[i-1]+dp[i-2]（可滚动成两个变量）
// 打家劫舍：dp[i] = max(dp[i-1], dp[i-2]+nums[i])   偷或不偷
// 最大子数组和：dp[i]=max(dp[i-1]+x, x)  → Kadane，全局取max
// 乘积最大子数组：同时维护 max 和 min（负负得正会翻转）
```

### 2. 背包（必背两种）

```cpp
// 0-1 背包（分割等和子集）：一维数组，i 倒序！
for (x : nums)
    for (j = target; j >= x; j--)
        dp[j] = dp[j] || dp[j-x];

// 完全背包（零钱兑换、单词拆分）：j 正序
for (x : coins)
    for (j = x; j <= amount; j++)
        dp[j] = min(dp[j], dp[j-x]+1);
```

> 口诀：**0-1 倒序防重复用，完全正序允许重复用。**
> 求方案数：`dp[j] += dp[j-x]`；求最值：`dp[j] = min/max(...)`。

### 3. 最长递增子序列 LIS

```cpp
// O(n²)：dp[i] = max(dp[j]+1)  ∀j<i, a[j]<a[i]
// O(nlogn)：tails 数组 + 二分替换（贪心+二分）
vector<int> tails;
for (x : a) {
    auto it = lower_bound(tails.begin(), tails.end(), x);
    if (it == tails.end()) tails.push_back(x);
    else *it = x;                     // 替换第一个 ≥x 的
}
return tails.size();
```

### 4. 完全平方数

`dp[i] = min(dp[i-j*j]+1)`，j*j ≤ i —— 完全背包变体。

### 5. 最长有效括号（DP 版）

`dp[i]` = 以 i 结尾的最长有效长度；`()` 结尾接前一个，`))` 结尾跳过配对段再拼。

---

## 十二、多维 DP

### 1. 路径类

```cpp
// 不同路径：dp[i][j] = dp[i-1][j] + dp[i][j-1]（可滚动一维）
// 最小路径和：dp[i][j] = min(上,左) + grid[i][j]
// 第一行第一列单独初始化
```

### 2. 双序列类（编辑距离/LCS 家族）

```cpp
// 最长公共子序列：
dp[i][j] = (a[i]==b[j]) ? dp[i-1][j-1]+1 : max(dp[i-1][j], dp[i][j-1]);

// 编辑距离：
dp[i][j] = (a[i]==b[j]) ? dp[i-1][j-1]
         : 1 + min({dp[i-1][j-1],   // 替换
                    dp[i-1][j],     // 删除
                    dp[i][j-1]});   // 插入
// 初始化：dp[i][0]=i, dp[0][j]=j
```

### 3. 区间/股票状态机

```cpp
// 杨辉三角：本行 = 上行错位相加，两端 1
// 旋转图像：先转置再左右翻转（原地）
// 股票含冷冻期/手续费：多状态 DP，每天在"持有/不持有/冷冻"间转移
```

---

## 十三、BFS / DFS / 图

### 1. 网格 DFS（岛屿类）

```cpp
void dfs(vector<vector<char>>& g, int i, int j) {
    if (越界 || g[i][j] != '1') return;
    g[i][j] = '0';                        // 淹没=visited
    dfs(g,i+1,j); dfs(g,i-1,j); dfs(g,i,j+1); dfs(g,i,j-1);   // 四个方向
}
// 岛屿数量：遍历每格，遇 '1' 计数+1 并淹没整岛
```

### 2. 多源 BFS（腐烂的橘子）

```cpp
// 所有源头一起入队，逐层扩散，层数=时间；结束检查是否还有新鲜
queue<pair<int,int>> q;   // 先放入所有腐烂橘子
while (!q.empty()) { int n=q.size(); 处理本层, 新鲜变腐烂入队; 分钟++; }
```

### 3. 拓扑排序（课程表）

```cpp
// BFS 版（Kahn）：入度为 0 入队 → 出队计数 → 邻居入度减 1，减到 0 入队
// 完成数 == 课程数 → 可修完
```

### 4. 排列硬币/回溯网格（数独类）同网格 DFS + 撤销标记。

---

## 十四、位运算与技巧题

| 技巧 | 代码 | 适用 |
|---|---|---|
| 异或消对 | `a^a=0, a^0=a` | 只出现一次的数字 |
| 摩尔投票 | 候选+计数，同加异减，归零换人 | 多数元素（>n/2） |
| 原地哈希 | `nums[abs(x)-1] 取负` 标记出现过 | 缺失的第一个正数 |
| 弗洛伊德判环 | 数组当链表：`i → nums[i]`，快慢相遇+回头找入口 | 寻找重复数 |
| 前缀异或 | 区间异或查询 O(1) | XOR 类区间题 |
| 下一个排列 | 从右找第一个升序对 → 换右边刚好大的 → 反转后缀 | nextPermutation |
| 轮转数组 | **三次反转**：全反 → 反前 k → 反后 n-k | 轮转数组 |
| 除自身以外乘积 | 左右两遍前缀积，O(1) 空间 | productExceptSelf |
| 缺失数字求和 | `n(n+1)/2 - sum` | 简单场景 |

```cpp
// 摩尔投票（背）
int cand=0, cnt=0;
for (x : nums) {
    if (cnt==0) cand=x;
    cnt += (x==cand) ? 1 : -1;
}
return cand;
```

---

## 十五、手写排序

### 快排 partition（必背，手写频率第一）

```cpp
int partition(vector<int>& a, int l, int r) {
    int pivot = a[r], i = l;          // 以最右为基准
    for (int j = l; j < r; j++)
        if (a[j] < pivot) swap(a[i++], a[j]);
    swap(a[i], a[r]);
    return i;
}
void quickSort(vector<int>& a, int l, int r) {
    if (l >= r) return;
    int p = partition(a, l, r);
    quickSort(a, l, p-1); quickSort(a, p+1, r);
}
// 快速选择找第k大：只递归 pivot 一侧，平均 O(n)
```

### 归并（链表排序用）

找中点（快慢）→ 断成两半 → 递归排 → 合并两个有序链表。

---

## 十六、STL 速查

```cpp
sort(a.begin(), a.end());                    // 默认升序
sort(a.begin(), a.end(), greater<int>());    // 降序
stable_sort / partial_sort / nth_element(a.begin(), a.begin()+k, a.end()); // 第k位O(n)
reverse(a.begin(), a.end());
*max_element(a.begin(), a.end());
accumulate(a.begin(), a.end(), 0LL);         // 求和，注意用 long long 防溢出
lower_bound(a.begin(), a.end(), x);          // 第一个 >= x，返回迭代器
upper_bound(a.begin(), a.end(), x);          // 第一个 > x
s.substr(start, len);  s.find(t);  to_string(x);  stoi(s);
unordered_map / unordered_set                // 平均 O(1)，笔试首选
map / set                                    // 有序 O(logn)，要"按序/找边界"才用
priority_queue<int> maxHeap;                 // 默认大顶！
priority_queue<int, vector<int>, greater<int>> minHeap;
queue / stack / deque
pair<int,int> / tuple / struct 自定义比较：
    sort(v.begin(), v.end(), [](auto& x, auto& y){ return x.first < y.first; });
INT_MAX / INT_MIN                            // <climits>
```

---

## 十七、易错点清单（交卷前过一遍）

- [ ] 整数溢出：`mid = l+(r-l)/2`；求和/乘法用 `long long`
- [ ] 数组越界：先判 `i < n` 再访问 `a[i]`；`a[i+1]` 类注意尾部
- [ ] 空输入：链表/树先判 `nullptr`，数组先判 `empty()`
- [ ] 二分边界：`l<=r` 配 `mid±1`；找边界时 `==` 分支往哪缩想清楚
- [ ] 背包遍历方向：**0-1 倒序、完全正序**（最常考最容易反）
- [ ] 回溯忘记**撤销选择**；used 数组忘记恢复
- [ ] 单调栈存**下标**不是值
- [ ] BFS 忘标记 visited → 死循环；多源 BFS 记得所有源先入队
- [ ] 快慢指针找中点：偶数长度时 slow 偏左还是偏右，画图确认
- [ ] unordered_map 用 `[]` 会自动插入默认值，只查存在用 `count/find`
- [ ] 字符串转数字注意负号与前导零；char 转 int 减 `'0'`
- [ ] 优先队列默认是**大顶堆**，要小顶堆必须写全三个模板参数

---

## 附：题型 → 套路速查表

| 看到什么 | 想什么 |
|---|---|
| 有序数组 + 找配对/边界 | 二分 or 相向双指针 |
| 子串/子数组 + 最长/最短/满足条件 | 滑动窗口 |
| 子数组 + 和为 K | 前缀和 + 哈希 |
| 下一个更大/更小 | 单调栈 |
| 第 K 大/小、Top K、中位数 | 堆 or 快速选择 |
| 所有方案（排列/组合/子集/棋盘） | 回溯 |
| 最值 + 有重叠子问题 | DP（先想背包/路径/双序列哪个家族） |
| 网格 + 连通块/最短步数 | DFS 淹没 / BFS 分层 |
| 依赖关系 + 能否完成 | 拓扑排序 |
| 链表操作 | 哑结点 + 画图 |
| 树的深度/路径/直径类 | 递归三件套，后序拿子树信息 |
| 出现次数/配对 | 异或、摩尔投票、哈希 |
| 原地 O(1) 空间 | 数组自身当哈希（取负/交换到正确位） |
