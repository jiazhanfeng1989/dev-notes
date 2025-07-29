---
id: iuoqqw1cg9yijbpy5u58rwb
title: Network
desc: ''
updated: 1753771966489
created: 1748595426037
---

# 机场 vs VPN
| 特性    | 机场（V2Ray/SSR/Trojan）              | VPN（如 ExpressVPN、Surfshark） |
| ----- | --------------------------------- | --------------------------- |
| 技术协议  | V2Ray、Shadowsocks、Trojan 等        | OpenVPN、WireGuard、IKEv2 等   |
| 控制粒度  | ✅ 可精细控制（按 App / 域名分流）      | ❌ 全局代理或手动排除                 |
| 支持分流  | ✅ 支持（国内走直连，国外走代理）        | ❌ 通常为全局模式                   |
| 客户端配置 | ⚠️ 需自行导入订阅、配置客户端           | ✅ 官方客户端一键连接                 |
| 节点灵活性 | ✅ 多地区节点可选（通常十几个）          | ⚠️ 有但较固定（VPN 一般 10\~20 国家）  |
| 稳定性   | ⚠️ 取决于机场质量和地区封锁状况           | ✅ 高端 VPN 稳定性高               |
| 安全匿名性 | ⚠️ 一般（很多机场不支持匿名支付）        | ✅ 高级 VPN 强调隐私保护             |
| 法律风险  | 🚫 使用有灰色风险，需合规               | ⚠️ 某些国家（如中国）不允许使用商业 VPN     |
| 价格    | 💰 ¥10\~60/月（视机场定价）             | 💰 ¥20\~60/月（如 Surfshark）   |
| 适合对象  | ⚙️ 技术熟悉用户（自由、可控）           | 🟢 小白用户（简单、一键连）             |
| 支持平台  | Windows / macOS / iOS / Android 等 | 同样支持多平台                     |

# 机场客户端
| 客户端名称                 | 支持平台                     | 分流规则 | UI 友好 | 支持订阅链接 | 自定义配置 | 适合用户类型      |
| --------------------- | ------------------------ | ---- | ----- | ------ | ----- | ----------- |
| **Clash Verge Rev**   | Windows / macOS / Linux  | ✅ 支持 | ✅ 是   | ✅ 支持   | ✅ 强大  | 开发者、进阶用户    |
| **Clash for Windows** | Windows / macOS          | ✅ 支持 | ⚠️ 一般 | ✅ 支持   | ✅ 强大  | 技术用户、开发者    |
| **Clash Meta GUI**    | Windows / macOS / Linux  | ✅ 支持 | ✅ 是   | ✅ 支持   | ✅ 强大  | 高阶用户        |
| **ClashX**            | macOS                    | ✅ 支持 | ✅ 是   | ✅ 支持   | ✅ 一般  | macOS 普通用户  |
| **ClashX Pro**        | macOS                    | ✅ 支持 | ✅ 更强  | ✅ 支持   | ✅ 完善  | 商业/专业用户     |
| **Clash Meta（CLI）**   | Linux / Router / OpenWrt | ✅ 支持 | ❌ 命令行 | ✅ 支持   | ✅ 极强  | 高级用户 / 嵌入式  |
| **Shadowrocket**      | iOS                      | ✅ 支持 | ✅ 是   | ✅ 支持   | ✅ 丰富  | iPhone 用户   |
| **Stash**             | iOS                      | ✅ 支持 | ✅ 极佳  | ✅ 支持   | ✅ 丰富  | iPhone 高级用户 |
| **Surfboard**         | Android / iOS            | ✅ 支持 | ✅ 是   | ✅ 支持   | ✅ 丰富  | 移动端开发者      |
| **Clash for Android** | Android                  | ✅ 支持 | ⚠️ 一般 | ✅ 支持   | ✅ 丰富  | 安卓开发者       |

# 机场对比
| 名称                | 稳定性  | 速度表现 | 价格区间   | 协议支持                      | 流媒体支持   | 特色                     | 推荐人群    |
| ----------------- | ---- | ---- | ------ | ------------------------- | ------- | ---------------------- | ------- |
| **Nexitally**     | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ￥30+/月 | SS / V2Ray / Trojan       | ✅ 支持    | 高性能多节点                 | 中高端用户   |
| **AmyTelecom**    | ⭐⭐⭐  | ⭐⭐⭐  | ￥20+/月 | SSR / Trojan              | ⚠️ 部分支持 | 稳定普通用                  | 日常轻度用户  |
| **FlowerCloud**   | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ￥30+/月 | V2Ray / Trojan            | ✅ 支持    | 稳定流畅                   | 稳定优先用户  |
| **YToo**          | ⭐⭐⭐  | ⭐⭐⭐  | ￥15+/月 | V2Ray / Trojan            | ⚠️ 部分支持 | 简单易用                   | 轻度用户    |
| **Kuromis**       | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ￥40+/月 | V2Ray / Hysteria          | ✅ 支持    | 高端机场，线路丰富              | 重度用户    |
| **CreamData**     | ⭐⭐⭐  | ⭐⭐⭐  | ￥25+/月 | V2Ray / Trojan            | ⚠️ 需测试  | 老牌机场                   | 普通日常用户  |
| **FlyingBird**    | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ￥35+/月 | SS / V2Ray / Trojan       | ✅ 支持    | 多地出口，速度快               | 高端稳定需求  |
| **LinkCube**      | ⭐⭐⭐  | ⭐⭐⭐  | ￥20+/月 | V2Ray                     | ⚠️ 部分支持 | 技术向，订阅稳定               | 开发者     |
| **SSRCloud**      | ⭐⭐   | ⭐⭐   | ￥10 起  | SSR                       | ❌ 不支持   | 适合短期临时使用               | 临时用途    |
| **Hutao（胡桃）**     | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ￥15+/月 | V2Ray / Trojan            | ✅ 支持    | 稳定、支持 ChatGPT          | 学生、开发者  |
| **MaomaoCloud**   | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ￥19+/月 | 多协议                       | ✅ 支持    | 老牌机场，速度快，口碑好           | 常用重度用户  |
| **Just My Socks** | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | \$5+/月 | Trojan（搬瓦工官方）             | ✅ 支持    | 海外开发者首选，稳定长期           | 稳定开发使用  |
| **ANYNode**       | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ￥20+/月 | V2Ray / Hysteria / Trojan | ✅ 支持    | 多地区、支持 IPv6、Netflix 解锁 | 稳定流媒体用户 |


# 机场测试
[机场测速](https://www.duyaoss.com/archives/1/)

# 机场
[flowercloud](https://flowercloud.net/clientarea.php)
[hongxingcloud](https://hongxing.one/index.html)