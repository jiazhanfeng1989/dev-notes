#!/bin/bash

# 使用方法:
#   ./test_connection_timeout.sh <host> <port> [protocol]
# 示例:
#   ./test_connection_timeout.sh example.com 80 http
#   ./test_connection_timeout.sh example.com 443 https

HOST="${1:-test.example.com}"
PORT="${2:-80}"
PROTOCOL="${3:-http}"  # http 或 https

echo "=== 测试连接超时 ==="
echo "目标: $HOST:$PORT"
echo "协议: $PROTOCOL"
echo "开始时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# 记录开始时间戳
START=$(date +%s)

# 根据协议选择工具
if [ "$PROTOCOL" = "https" ]; then
    echo "使用 openssl s_client 测试 HTTPS 连接..."
    echo ""
    
    # 使用 openssl s_client 建立 SSL/TLS 连接
    {
        echo -e "GET /health HTTP/1.1\r"
        echo -e "Host: $HOST\r"
        # 不发送最后的空行，保持连接但不完成请求
        # 等待5分钟看服务器是否会断开
        sleep 300
    } | openssl s_client -connect $HOST:$PORT -servername $HOST 2>&1 &
    
    TEST_PID=$!
    TOOL_NAME="openssl"
else
    echo "使用 nc 测试 HTTP 连接..."
    echo ""
    
    # 使用 nc 建立连接，发送部分HTTP请求但不完成
    {
        echo -e "GET /health HTTP/1.1\r"
        echo -e "Host: $HOST\r"
        # 不发送最后的空行，保持连接但不完成请求
        # 等待5分钟看服务器是否会断开
        sleep 300
    } | nc -v $HOST $PORT 2>&1 &
    
    TEST_PID=$!
    TOOL_NAME="nc"
fi

echo "$TOOL_NAME 进程 PID: $TEST_PID"
echo "等待连接断开或超时(最多5分钟)..."
echo ""

# 监控进程状态
while kill -0 $TEST_PID 2>/dev/null; do
    ELAPSED=$(($(date +%s) - START))
    echo "[$(date '+%H:%M:%S')] 已等待 ${ELAPSED} 秒，连接仍然存活..."
    sleep 5
done

# 计算总时长
END=$(date +%s)
DURATION=$((END - START))

echo ""
echo "连接已断开"
echo "结束时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo "连接持续时间: ${DURATION} 秒"
echo ""

# 总结
if [ $DURATION -ge 55 ] && [ $DURATION -le 70 ]; then
    echo "结论: 超时时间约为 60 秒（AWS ALB 默认值）"
elif [ $DURATION -ge 115 ] && [ $DURATION -le 125 ]; then
    echo "结论: 超时时间约为 120 秒"
elif [ $DURATION -ge 295 ]; then
    echo "结论: 超时时间超过 5 分钟（或未配置超时）"
else
    echo "结论: 超时时间约为 ${DURATION} 秒"
fi
