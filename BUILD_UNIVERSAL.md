# 构建通用二进制应用指南

本指南将教你如何构建支持 Apple Silicon (arm64) 和 Intel (x86_64) 架构的通用二进制应用。

## 方法一：使用 Xcode 图形界面

### 1. 配置项目设置

1. **打开项目**
   - 在 Xcode 中打开 `EditorJumper-X.xcodeproj`

2. **选择项目和目标**
   - 点击项目导航器中的项目根节点
   - 在主编辑器中选择 "EditorJumper-X" 目标

3. **配置构建设置**
   - 点击 "Build Settings" 标签页
   - 在搜索框中输入 "Architectures"
   - 确保 `Architectures` 设置为 `Standard Architectures (Apple Silicon, Intel)`

4. **配置 "Build Active Architecture Only"**
   - 搜索 "Build Active Architecture Only"
   - Debug 配置：设置为 `Yes`（开发时更快）
   - Release 配置：设置为 `No`（发布时构建所有架构）

5. **重复配置其他目标**
   - 对 "EditorJumperForXcode" 扩展重复上述步骤
   - 对 "EditorJumperForXcodeXPCService" XPC 服务重复上述步骤

### 2. 构建应用

1. **选择构建配置**
   - 在 Xcode 顶部选择 "Any Mac" 作为目标设备
   - 选择 "Release" 配置（Product → Scheme → Edit Scheme → Run → Build Configuration）

2. **构建项目**
   - 按 `Cmd + B` 或选择 Product → Build
   - 或者选择 Product → Archive 创建归档

## 方法二：使用命令行工具

### 1. 使用提供的构建脚本

```bash
# 运行构建脚本
./build_universal.sh
```

### 2. 手动命令行构建

```bash
# 清理项目
xcodebuild clean -project EditorJumper-X.xcodeproj -scheme EditorJumper-X

# 构建通用二进制
xcodebuild build \
    -project EditorJumper-X.xcodeproj \
    -scheme EditorJumper-X \
    -configuration Release \
    ARCHS="arm64 x86_64" \
    ONLY_ACTIVE_ARCH=NO
```

## 验证构建结果

### 使用 lipo 命令验证架构

```bash
# 检查主应用
lipo -info build/EditorJumper-X.app/Contents/MacOS/EditorJumper-X

# 检查扩展
lipo -info build/EditorJumper-X.app/Contents/PlugIns/EditorJumperForXcode.appex/Contents/MacOS/EditorJumperForXcode

# 检查 XPC 服务
lipo -info build/EditorJumper-X.app/Contents/XPCServices/EditorJumperForXcodeXPCService.xpc/Contents/MacOS/EditorJumperForXcodeXPCService
```

期望的输出应该类似：
```
Architectures in the fat file: EditorJumper-X are: x86_64 arm64
```

## 重要配置说明

### 项目级别设置
- `ARCHS = "$(ARCHS_STANDARD)"` - 使用标准架构（包含 arm64 和 x86_64）
- `ONLY_ACTIVE_ARCH = NO` - 在 Release 配置中构建所有架构

### 部署目标
- `MACOSX_DEPLOYMENT_TARGET = 12.4` - 支持 macOS 12.4 及以上版本
- 这确保了与较旧的 Intel Mac 的兼容性

### 代码签名
- 确保所有目标都使用相同的开发团队 ID
- 自动代码签名应该能处理通用二进制

## 故障排除

### 常见问题

1. **构建失败 - 架构不匹配**
   - 确保所有依赖库都支持目标架构
   - 检查第三方框架是否为通用二进制

2. **代码签名问题**
   - 确保开发者证书支持所有架构
   - 检查 Provisioning Profile 设置

3. **性能问题**
   - Debug 构建时使用 `ONLY_ACTIVE_ARCH = YES` 提高构建速度
   - 只在 Release 构建时构建所有架构

### 验证步骤

1. **构建成功后**
   - 使用 `lipo -info` 验证所有二进制文件
   - 在不同架构的 Mac 上测试应用

2. **分发前检查**
   - 确保应用在 Intel 和 Apple Silicon Mac 上都能正常运行
   - 验证所有扩展和服务都正确加载

## 自动化构建

你可以将构建脚本集成到 CI/CD 流程中：

```bash
# 在 GitHub Actions 或其他 CI 系统中使用
./build_universal.sh
```

这样就能确保每次发布都包含通用二进制文件。 