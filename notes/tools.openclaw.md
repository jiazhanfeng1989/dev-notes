---
id: ml9c9ul0oeslxqk57tzq8mp
title: Openclaw
desc: ''
updated: 1770780114973
created: 1770776691493
---


# Description
Openclaw[https://github.com/openclaw/openclaw] is a Personal AI Assistant.


## Usage
``` bash
 # 查看帮助
openclaw --help
# 启动 gateway（前台模式）
openclaw gateway --force
# 安装为系统服务（LaunchAgent）
openclaw gateway install

# 检查 gateway 健康状态
openclaw health
# 查看 gateway 详细状态
openclaw gateway status
# 打开浏览器控制面板
openclaw dashboard

# 列出所有 skills 及状态（ready/missing）
openclaw skills list
# 查看某个 skill 的详细信息
openclaw skills info mcporter
# 列出所有 plugins 及状态（loaded/disabled）
openclaw plugins list

# 全局安装 mcporter
npm i -g mcporter

# 查看 mcporter 发现的所有 MCP servers（自动读取 Cursor 配置）
mcporter list
# 查看当前 mcporter 配置状态
mcporter config list
# 查看导入帮助
mcporter config import --help
# 从 Cursor 导入 mcp-atlassian 配置并持久化
mcporter config import cursor --copy --filter mcp-atlassian
# 复制到系统级配置目录（全局可用）
mkdir -p ~/.mcporter
cp ~/config/mcporter.json ~/.mcporter/mcporter.json

# 查看 mcp-atlassian 的所有 43 个工具签名
mcporter list mcp-atlassian
# 测试实际调用（列出 Jira 项目）
mcporter call mcp-atlassian.jira_get_all_projects --output json

# LaunchAgent 管理 Gateway 启停

# 安装服务（生成 plist 文件）
openclaw gateway install
# 卸载服务（移除 plist 文件）
openclaw gateway uninstall
# 查看状态
openclaw gateway status

# 启动
openclaw gateway start
# 停止,会卸载掉服务
openclaw gateway stop
# 重启
openclaw gateway restart
# 前台运行（调试用）
openclaw gateway run

# 健康检查
openclaw health

# 启动（加载服务）
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/ai.openclaw.gateway.plist
# 停止（卸载服务）
launchctl bootout gui/$(id -u) ~/Library/LaunchAgents/ai.openclaw.gateway.plist
# 查看服务状态
launchctl print gui/$(id -u)/ai.openclaw.gateway

# 实时查看 gateway 日志
openclaw logs
# 日志文件位置
# /tmp/openclaw/openclaw-2026-02-11.log
```
