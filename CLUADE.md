当前小工具主要功能是 提供cmd 快捷命令提示，以及其他(待完善，这里其实我有想过融入微信输入法，但是一直没找到合适的切入口)

---

## QuickCmd - 命令速查工具

**简介**
macOS 桌面悬浮窗口应用，快速查找和复制常用命令。

**核心功能**
- 桌面悬浮显示，半透明背景
- 实时搜索过滤命令
- 一键复制命令到剪贴板
- 支持命令参数说明和示例输出
- 点击展开详细信息
- 拖动排序命令
- 记住窗口位置和大小

**技术栈**
Swift + SwiftUI

**平台**
macOS

---

## 配置文件

**存储路径**
```
~/.quickcmd_settings.json
```

**文件格式**
```json
{
  "commands": [
    {
      "id": "uuid-string",
      "category": "Linux",
      "command": "wget",
      "briefDesc": "下载文件",
      "params": [
        {"param": "-L", "desc": "接受跳转"},
        {"param": "-O", "desc": "指定路径和文件名"}
      ],
      "details": "详细说明文字（可选）",
      "example": "wget -L -O /path/file.tar https://example.com/file.tar"
    }
  ],
  "window": {
    "x": 100,
    "y": 100,
    "width": 380,
    "height": 550
  }
}
```

**字段说明**

*命令字段（commands 数组）：*
- `id`: UUID，自动生成
- `category`: 分类名称（如：Linux、Nano、访达）
- `command`: 命令或快捷键
- `briefDesc`: 简短描述（一行）
- `params`: 参数列表（可选）
  - `param`: 参数名
  - `desc`: 参数说明
- `details`: 详细说明（可选）
- `example`: 示例命令或输出（可选）

*窗口设置（window 对象，可选）：*
- `x`: 窗口X坐标
- `y`: 窗口Y坐标
- `width`: 窗口宽度
- `height`: 窗口高度

**配置文件特性**
- 包含所有命令数据和窗口位置
- 支持跨用户/跨设备同步设置
- 移动窗口或调整大小会自动保存
- 分享配置文件可完整恢复他人的设置

---

## 打包与分发

### 方式1：Archive 打包（推荐）

1. **在 Xcode 中打包**
   ```
   Product → Archive
   等待编译完成...
   ```

2. **分发应用**
   ```
   Archive 完成后会自动打开 Organizer
   选择刚才的 Archive → Distribute App
   选择 "Copy App"
   选择保存位置
   ```

3. **安装使用**
   ```bash
   # 将导出的 QuickCmd.app 复制到应用程序文件夹
   cp -r QuickCmd.app /Applications/

   # 从启动台或访达运行
   open /Applications/QuickCmd.app
   ```

### 方式2：直接复制编译产物（快速测试）

```bash
# 在 Xcode 中编译
Cmd+B

# 在 Xcode 左侧 Products 中找到 QuickCmd.app
# 右键 → Show in Finder → 复制到 /Applications
```
### 开机自启

~~~sh
# 添加开机自启
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/QuickCmd.app", hidden:false}'

# 查看当前登录项
osascript -e 'tell application "System Events" to get the name of every login item'

# 移除（如需要）
osascript -e 'tell application "System Events" to delete login item "QuickCmd"'
~~~
### 首次运行

```bash
# 复制示例配置
cp 项目目录/.quickcmd_settings.json.bak ~/.quickcmd_settings.json

# 运行应用
open /Applications/QuickCmd.app
```

---

## LLM 生成命令提示词

使用以下提示词让 LLM 生成符合格式的命令数据：

```
请将以下命令整理为 JSON 格式，用于 QuickCmd 工具。

要求：
1. 使用以下 JSON 结构
2. id 字段使用随机 UUID（格式：A1B2C3D4-E5F6-7890-ABCD-EF1234567890）
3. category 根据命令类型分类（如：Linux、Git、Docker、Vim 等）
4. command 是核心命令或快捷键
5. briefDesc 是一行简短描述
6. 如果命令有参数，添加 params 数组，列出每个参数及说明
7. 如果需要详细说明，添加 details 字段
8. 如果有典型示例，添加 example 字段

JSON 格式（单个命令）：
{
  "id": "A1B2C3D4-E5F6-7890-ABCD-EF1234567890",
  "category": "分类",
  "command": "命令",
  "briefDesc": "描述",
  "params": [{"param": "参数", "desc": "说明"}],
  "details": "详细说明",
  "example": "示例"
}

需要整理的命令：
[在这里粘贴你的命令]

请直接返回 JSON 数组，不要有其他文字。
```

**示例输入**
```
docker ps -a  查看所有容器
docker rm $(docker ps -aq)  删除所有容器
```

**示例输出**
```json
[
  {
    "id": "A1B2C3D4-E5F6-7890-ABCD-EF1234567890",
    "category": "Docker",
    "command": "docker ps",
    "briefDesc": "查看容器",
    "params": [
      {"param": "-a", "desc": "显示所有容器（包括停止的）"}
    ]
  },
  {
    "id": "B2C3D4E5-F6A7-8901-BCDE-F12345678901",
    "category": "Docker",
    "command": "docker rm",
    "briefDesc": "删除容器",
    "example": "docker rm $(docker ps -aq)  # 删除所有容器"
  }
]
```

**使用方法**
1. 用 LLM 生成命令 JSON 数组
2. 打开配置文件：`code ~/.quickcmd_settings.json`
3. 将生成的命令添加到 `commands` 数组中
4. 保存文件
5. 重启 QuickCmd 应用即可看到新命令

---

## 常见操作

**备份配置**
```bash
cp ~/.quickcmd_settings.json ~/backup/quickcmd_settings_$(date +%Y%m%d).json
```

**恢复配置**
```bash
cp ~/backup/quickcmd_settings_20250128.json ~/.quickcmd_settings.json
```

**分享配置给他人**
```bash
# 发送配置文件
scp ~/.quickcmd_settings.json user@host:~/

# 接收方使用
cp ~/quickcmd_settings.json ~/.quickcmd_settings.json
```

**重置为默认**
```bash
rm ~/.quickcmd_settings.json
# 重新打开应用会显示空列表，然后复制备份文件即可
cp 项目目录/.quickcmd_settings.json.bak ~/.quickcmd_settings.json
```
