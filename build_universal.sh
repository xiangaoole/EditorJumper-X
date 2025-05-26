#!/bin/bash

# 构建通用二进制文件的脚本
# 支持 Apple Silicon (arm64) 和 Intel (x86_64) 架构

set -e

echo "🚀 开始构建通用二进制文件..."

# 创建构建目录
mkdir -p build

# 清理之前的构建
echo "🧹 清理之前的构建..."
xcodebuild clean -project EditorJumper-X.xcodeproj -scheme EditorJumper-X

# 构建 Release 版本（包含所有架构）
echo "🔨 构建 Release 版本..."
xcodebuild build \
    -project EditorJumper-X.xcodeproj \
    -scheme EditorJumper-X \
    -configuration Release \
    -derivedDataPath build/DerivedData \
    ARCHS="arm64 x86_64" \
    ONLY_ACTIVE_ARCH=NO

# 查找构建的应用
BUILD_DIR="build/DerivedData/Build/Products/Release"
APP_PATH="$BUILD_DIR/EditorJumper-X.app"

if [ -d "$APP_PATH" ]; then
    echo "✅ 构建成功！"
    echo "📍 应用位置: $APP_PATH"
    
    # 验证架构
    echo "🔍 验证构建的架构..."
    
    # 检查主应用
    MAIN_BINARY="$APP_PATH/Contents/MacOS/EditorJumper-X"
    if [ -f "$MAIN_BINARY" ]; then
        echo "主应用架构:"
        lipo -info "$MAIN_BINARY"
    fi
    
    # 检查扩展
    EXTENSION_BINARY="$APP_PATH/Contents/PlugIns/EditorJumperForXcode.appex/Contents/MacOS/EditorJumperForXcode"
    if [ -f "$EXTENSION_BINARY" ]; then
        echo "扩展架构:"
        lipo -info "$EXTENSION_BINARY"
    fi
    
    # 检查 XPC 服务
    XPC_BINARY="$APP_PATH/Contents/XPCServices/EditorJumperForXcodeXPCService.xpc/Contents/MacOS/EditorJumperForXcodeXPCService"
    if [ -f "$XPC_BINARY" ]; then
        echo "XPC 服务架构:"
        lipo -info "$XPC_BINARY"
    fi
    
    # 复制到方便的位置
    echo "📦 复制应用到 build 目录..."
    cp -R "$APP_PATH" build/
    echo "✅ 通用二进制文件构建完成！"
    echo "📍 最终位置: build/EditorJumper-X.app"
else
    echo "❌ 构建失败，找不到应用文件"
    exit 1
fi 