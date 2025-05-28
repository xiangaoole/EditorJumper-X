#!/bin/bash

# EditorJumper-X Release Creation Script

set -e

APP_NAME="EditorJumper-X"
VERSION="1.2.4"  # 更新为实际版本号
BUILD_DIR="build"
RELEASE_DIR="release"
DMG_NAME="${APP_NAME}-${VERSION}.dmg"

echo "🚀 Creating release for ${APP_NAME} v${VERSION}"

# 清理之前的构建
rm -rf "${BUILD_DIR}"
rm -rf "${RELEASE_DIR}"
mkdir -p "${RELEASE_DIR}"

# 构建应用
echo "📦 Building application..."
xcodebuild -project "${APP_NAME}.xcodeproj" \
           -scheme "${APP_NAME}" \
           -configuration Release \
           -derivedDataPath "${BUILD_DIR}" \
           -archivePath "${BUILD_DIR}/${APP_NAME}.xcarchive" \
           archive

# 导出应用
echo "📤 Exporting application..."
xcodebuild -exportArchive \
           -archivePath "${BUILD_DIR}/${APP_NAME}.xcarchive" \
           -exportPath "${BUILD_DIR}/export" \
           -exportOptionsPlist exportOptions.plist

# 创建 DMG
echo "💿 Creating DMG..."
APP_PATH="${BUILD_DIR}/export/EditorJumper for Xcode.app"

if [ -d "${APP_PATH}" ]; then
    # 创建临时 DMG 目录
    DMG_DIR="${BUILD_DIR}/dmg"
    mkdir -p "${DMG_DIR}"
    
    # 复制应用到 DMG 目录
    cp -R "${APP_PATH}" "${DMG_DIR}/"
    
    # 创建 Applications 链接
    ln -s /Applications "${DMG_DIR}/Applications"
    
    # 创建 DMG
    hdiutil create -volname "${APP_NAME}" \
                   -srcfolder "${DMG_DIR}" \
                   -ov -format UDZO \
                   "${RELEASE_DIR}/${DMG_NAME}"
    
    echo "✅ DMG created: ${RELEASE_DIR}/${DMG_NAME}"
    
    # 计算 SHA256
    SHA256=$(shasum -a 256 "${RELEASE_DIR}/${DMG_NAME}" | cut -d' ' -f1)
    echo "🔐 SHA256: ${SHA256}"
    echo "${SHA256}" > "${RELEASE_DIR}/${DMG_NAME}.sha256"
    
else
    echo "❌ Application not found at ${APP_PATH}"
    exit 1
fi

echo "🎉 Release package ready in ${RELEASE_DIR}/" 

gh release create v${VERSION} ${RELEASE_DIR}/${DMG_NAME} --title "EditorJumper-X v${VERSION}" --notes "EditorJumper-X v${VERSION}"