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
~/.quickcmd_commands.json
```

**文件格式**
```json
[
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
]
```

**字段说明**
- `id`: UUID，自动生成
- `category`: 分类名称（如：Linux、Nano、访达）
- `command`: 命令或快捷键
- `briefDesc`: 简短描述（一行）
- `params`: 参数列表（可选）
  - `param`: 参数名
  - `desc`: 参数说明
- `details`: 详细说明（可选）
- `example`: 示例命令或输出（可选）

---

## LLM 生成命令提示词

使用以下提示词让 LLM 生成符合格式的命令数据：

```
请将以下命令整理为 JSON 格式，用于 QuickCmd 工具。

要求：
1. 使用以下 JSON 结构
2. id 字段使用随机 UUID
3. category 根据命令类型分类（如：Linux、Git、Docker、Vim 等）
4. command 是核心命令或快捷键
5. briefDesc 是一行简短描述
6. 如果命令有参数，添加 params 数组，列出每个参数及说明
7. 如果需要详细说明，添加 details 字段
8. 如果有典型示例，添加 example 字段

JSON 格式：
{
  "id": "uuid",
  "category": "分类",
  "command": "命令",
  "briefDesc": "描述",
  "params": [{"param": "参数", "desc": "说明"}],
  "details": "详细说明",
  "example": "示例"
}

需要整理的命令：
[在这里粘贴你的命令]
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
    "id": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
    "category": "Docker",
    "command": "docker ps",
    "briefDesc": "查看容器",
    "params": [
      {"param": "-a", "desc": "显示所有容器（包括停止的）"}
    ]
  },
  {
    "id": "b2c3d4e5-f6a7-8901-bcde-f12345678901",
    "category": "Docker",
    "command": "docker rm",
    "briefDesc": "删除容器",
    "example": "docker rm $(docker ps -aq)  # 删除所有容器"
  }
]
```

**使用方法**
1. 用 LLM 生成命令 JSON
2. 复制生成的 JSON 数组
3. 粘贴到 `~/.quickcmd_commands.json` 文件中（合并到现有数组）
4. 重启 QuickCmd 应用即可看到新命令


Product → Archive → Distribute App → Copy App
导出 .app 文件到 /Applications