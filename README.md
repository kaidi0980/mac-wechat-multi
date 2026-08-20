# Mac 微信双开

不用上传微信安装包，也不用安装第三方多开软件。这个仓库只提供教程和脚本：脚本会使用你自己 Mac 上已经安装的微信，在本机创建一个独立副本。

## 原理

脚本会完成四件事：

1. 找到本机已安装的微信；
2. 复制到个人 `Applications` 文件夹；
3. 修改副本的 `CFBundleIdentifier`；
4. 使用 macOS 自带的 `codesign` 重新签名并启动。

副本第一次打开时需要扫码登录第二个账号。原版微信不会被修改，也不需要退出登录。

## 使用条件

- macOS；
- 已经从官方来源安装微信；
- 微信通常位于 `/Applications/微信.app` 或 `/Applications/WeChat.app`；
- 第一次运行时允许 macOS 执行本地脚本。

## 快速使用

在终端进入本仓库目录后执行：

```zsh
/bin/zsh scripts/create-wechat-clone.sh
```

脚本默认生成：

```text
~/Applications/微信2.app
```

创建完成后会自动打开新的微信登录窗口。用第二个微信账号扫码即可，原来的微信无需退出。

## 指定路径、名称和身份

如果脚本没有自动找到微信，可以手动指定路径：

```zsh
/bin/zsh scripts/create-wechat-clone.sh "/Applications/微信.app" "微信2.app" "com.local.wechat.clone2"
```

创建第三个副本：

```zsh
/bin/zsh scripts/create-wechat-clone.sh "/Applications/微信.app" "微信3.app" "com.local.wechat.clone3"
```

每个副本都要使用不同的 App 名称和 Bundle ID。目标副本已经存在时，脚本会停止，不会覆盖旧副本。

## 以后如何打开

原版微信：

```zsh
/usr/bin/open -n "/Applications/微信.app"
```

微信2：

```zsh
/usr/bin/open -n "$HOME/Applications/微信2.app"
```

也可以在 Finder 中打开个人文件夹里的 `Applications`，双击微信2，或将它拖到 Dock 栏。

## 自定义图标

1. 准备一张正方形 PNG 图片；
2. 用“预览”打开图片，按 `Command + A`，再按 `Command + C`；
3. 在 Finder 中选中 `微信2.app`，按 `Command + I`；
4. 点击简介窗口左上角的 App 图标；
5. 按 `Command + V` 粘贴新图标。

## 常见问题

### 终端提示 `command not found`

可以先修复当前终端窗口：

```zsh
export PATH="/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin"
```

本仓库的脚本使用系统命令的完整路径，不需要修改 `.zshrc`，也不需要 `sudo`。

### 提示无法验证开发者

在 Finder 中找到微信2，右键选择“打开”，再确认一次“打开”。如果仍被拦截，到“系统设置 → 隐私与安全性”查看是否有“仍要打开”。

### 微信更新后副本不能启动

副本不会自动跟随原版微信更新。建议保留原版微信不动，从更新后的原版重新创建一个新副本。

## 安全与责任说明

- 本仓库不包含微信 App、安装包、聊天记录、登录数据或钥匙串内容；
- 不要把已经生成的 `.app` 上传到仓库；
- 不要把本机的 `Library/Containers`、`Keychains` 等目录上传；
- 这是本地副本方案，不是微信官方多开功能；
- 修改后的副本使用本地临时签名，可能受到 macOS 安全策略影响；
- 请仅在自己的 Mac 上使用，并自行确认微信软件许可和账号风险。

## 给 Codex 的使用提示

可以把本仓库链接发给 Codex，并使用下面的提示：

```text
请先阅读这个仓库的 README。只操作我本机已经安装的微信，不下载或上传微信 App，不修改原版微信，不读取钥匙串、聊天记录或登录数据。执行脚本前先告诉我将要做什么，完成后打开微信副本的扫码登录窗口。
```

## 作为 Codex Skill 使用

本仓库已经内置一个可复用的 Skill，目录如下：

```text
skills/mac-wechat-multi/
├── SKILL.md
├── agents/openai.yaml
└── scripts/create-wechat-clone.sh
```

在支持自定义 Skill 的 Codex 中，把 `skills/mac-wechat-multi` 整个文件夹放进你的 Skill 目录，然后对 Codex 说：

```text
请使用 mac-wechat-multi Skill，在我这台 Mac 已经安装的微信基础上创建微信2。不要下载或上传微信 App，不修改原版微信，不读取聊天记录、钥匙串或登录数据。执行前先告诉我将要做什么。
```

Skill 只会调用本机脚本创建微信副本，不会把微信安装包上传到 GitHub。首次登录第二个账号通常仍需要扫码；原版微信无需退出。
