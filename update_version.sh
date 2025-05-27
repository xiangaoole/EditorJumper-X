#!/bin/bash

# 批量更新版本号脚本

set -e

# 设置新版本号
NEW_VERSION="1.0.1"  # 修改为你想要的版本号
NEW_BUILD="3"        # 修改为你想要的构建号

PROJECT_FILE="EditorJumper-X.xcodeproj/project.pbxproj"

echo "🔄 Updating version to ${NEW_VERSION} (build ${NEW_BUILD})"

# 备份原文件
cp "${PROJECT_FILE}" "${PROJECT_FILE}.backup"

# 更新 MARKETING_VERSION (版本号)
sed -i '' "s/MARKETING_VERSION = [^;]*/MARKETING_VERSION = ${NEW_VERSION}/g" "${PROJECT_FILE}"

# 更新 CURRENT_PROJECT_VERSION (构建号)
sed -i '' "s/CURRENT_PROJECT_VERSION = [^;]*/CURRENT_PROJECT_VERSION = ${NEW_BUILD}/g" "${PROJECT_FILE}"

echo "✅ Version updated successfully!"
echo "📝 Please also update the version in:"
echo "   - create_release.sh (VERSION variable)"
echo "   - homebrew-cask-formula.rb (version field)"

# 验证更改
echo ""
echo "🔍 Updated versions:"
grep "MARKETING_VERSION" "${PROJECT_FILE}" | head -3
grep "CURRENT_PROJECT_VERSION" "${PROJECT_FILE}" | head -3 