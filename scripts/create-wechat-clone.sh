#!/bin/zsh

set -euo pipefail

# This script does not download or distribute WeChat.
# It only creates a local copy from an app already installed on this Mac.

SOURCE_APP="${1:-}"
CLONE_NAME="${2:-微信2.app}"
BUNDLE_ID="${3:-com.local.wechat.clone2}"

fail() {
  print -u2 -- "错误：$*"
  exit 1
}

find_source_app() {
  local candidate result

  for candidate in "/Applications/微信.app" "/Applications/WeChat.app"; do
    if [[ -d "$candidate" ]]; then
      print -r -- "$candidate"
      return 0
    fi
  done

  result=$(
    /usr/bin/mdfind 'kMDItemContentType == "com.apple.application-bundle"' |
      /usr/bin/grep -E '/(微信|WeChat)\.app$' |
      /usr/bin/head -n 1 || true
  )

  [[ -n "$result" ]] || return 1
  print -r -- "$result"
}

if [[ -z "$SOURCE_APP" ]]; then
  SOURCE_APP="$(find_source_app || true)"
fi

[[ -n "$SOURCE_APP" ]] || fail "没有找到微信 App。请手动指定微信路径。"
[[ -d "$SOURCE_APP" ]] || fail "微信路径不存在：$SOURCE_APP"

if [[ "$CLONE_NAME" != *.app ]]; then
  CLONE_NAME="${CLONE_NAME}.app"
fi

DEST_DIR="$HOME/Applications"
DEST_APP="$DEST_DIR/$CLONE_NAME"
INFO_PLIST="$DEST_APP/Contents/Info.plist"

[[ "$SOURCE_APP" != "$DEST_APP" ]] || fail "源 App 和目标副本不能是同一个路径。"
[[ ! -e "$DEST_APP" ]] || fail "目标已存在：$DEST_APP。请换一个副本名称。"

/bin/mkdir -p "$DEST_DIR"
/usr/bin/ditto "$SOURCE_APP" "$DEST_APP"

/usr/bin/plutil \
  -replace CFBundleIdentifier \
  -string "$BUNDLE_ID" \
  "$INFO_PLIST"

/usr/bin/codesign \
  --force \
  --deep \
  --sign - \
  "$DEST_APP"

print -- "微信副本创建成功：$DEST_APP"
print -- "正在打开新的登录窗口……"
/usr/bin/open -n "$DEST_APP"
