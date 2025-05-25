# Xcode to Cursor 跳转功能实现计划

## 架构概述 🏗️

采用 **主 App + XPC Service + Xcode Extension** 的三层架构：

1. **主 App (`EditorJumper-X/`)**：拥有文件访问权限，管理 XPC Service
2. **XPC Service (`EditorJumperForXcodeXPCService/`)**：中间层，处理文件路径获取和 Cursor 集成
3. **Xcode Extension (`EditorJumperForXcode/`)**：获取光标位置，通过 XPC 触发跳转

## 实现进度 ✅

### ✅ 已完成
- [x] 创建 XPC Service 协议定义
- [x] 实现 XPC Service 核心功能
  - [x] `getCurrentFilePath()` - 使用 AppleScript 获取文件路径
  - [x] `openInCursor()` - 打开文件到 Cursor
  - [x] `jumpToCursor()` - 组合操作
- [x] 更新 Xcode Extension 使用 XPC Service
- [x] 添加错误处理和异步操作支持

### 🔄 进行中
- [ ] 修复编译错误
  - [ ] 解决 XcodeKit 模块导入问题
  - [ ] 确保协议在所有 target 中可见
- [ ] 配置项目设置
  - [ ] 设置 XPC Service 权限
  - [ ] 配置 App Sandbox 权限

### 📋 待完成

#### 1. 项目配置 ⚙️
- [ ] **XPC Service 配置**
  - [ ] 检查 `Info.plist` 配置
  - [ ] 设置正确的 Bundle Identifier
  - [ ] 配置 XPC Service 权限 (entitlements)
  
- [ ] **主 App 配置**
  - [ ] 添加文件访问权限 (`com.apple.security.files.user-selected.read-write`)
  - [ ] 添加 AppleScript 权限 (`com.apple.security.automation.apple-events`)
  - [ ] 配置 XPC Service 连接权限

- [ ] **Extension 配置**
  - [ ] 确保 Extension 可以连接到 XPC Service
  - [ ] 配置快捷键绑定

#### 2. 功能增强 🚀
- [ ] **错误处理优化**
  - [ ] 添加更详细的错误信息
  - [ ] 实现重试机制
  - [ ] 添加超时处理

- [ ] **用户体验改进**
  - [ ] 添加状态指示器
  - [ ] 支持多种文件类型
  - [ ] 添加配置选项

- [ ] **Cursor 集成优化**
  - [ ] 检测 Cursor 是否已安装
  - [ ] 支持不同的 Cursor 安装路径
  - [ ] 添加备用编辑器支持

#### 3. 测试和调试 🧪
- [ ] **单元测试**
  - [ ] XPC Service 功能测试
  - [ ] AppleScript 执行测试
  - [ ] 文件路径解析测试

- [ ] **集成测试**
  - [ ] 端到端跳转测试
  - [ ] 不同文件类型测试
  - [ ] 错误场景测试

- [ ] **性能测试**
  - [ ] XPC 通信延迟测试
  - [ ] 内存使用测试
  - [ ] 并发操作测试

#### 4. 部署和分发 📦
- [ ] **代码签名**
  - [ ] 配置开发者证书
  - [ ] 设置 App ID 和权限
  - [ ] 配置 Provisioning Profile

- [ ] **打包和分发**
  - [ ] 创建安装包
  - [ ] 编写用户文档
  - [ ] 准备 App Store 提交材料

## 技术细节 🔧

### XPC Service 通信流程
```
Xcode Extension → XPC Service → AppleScript → Xcode
                              ↓
                         Shell Command → Cursor
```

### 关键文件
- `EditorJumperForXcodeXPCServiceProtocol.swift` - XPC 协议定义
- `EditorJumperForXcodeXPCService.swift` - XPC Service 实现
- `SourceEditorCommand.swift` - Xcode Extension 入口

### 权限要求
- **主 App**: 文件访问、AppleScript 执行
- **XPC Service**: Shell 命令执行
- **Extension**: XPC Service 连接

## 已知问题 ⚠️

1. **编译错误**: `No such module 'XcodeKit'`
   - 需要确保 Extension target 正确配置
   
2. **协议可见性**: XPC 协议需要在多个 target 中可见
   - 考虑使用共享框架或复制协议定义

3. **沙盒限制**: Extension 运行在严格的沙盒环境中
   - 需要通过 XPC Service 绕过限制

## 下一步行动 🎯

1. **立即**: 修复编译错误，确保项目可以构建
2. **短期**: 完成基本功能测试，验证 XPC 通信
3. **中期**: 优化用户体验，添加错误处理
4. **长期**: 完善测试，准备发布

---

**注意**: 这个架构设计充分考虑了 macOS 沙盒限制和安全要求，通过 XPC Service 实现了功能分离和权限隔离。 