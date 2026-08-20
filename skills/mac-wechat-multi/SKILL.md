---
name: mac-wechat-multi
description: Create and launch an independent second WeChat app on macOS from a locally installed WeChat, without downloading, uploading, or inspecting account data. Use for Mac 微信双开/多开 requests.
---

# Mac 微信多开

Use this skill only when the user is working on macOS and wants an independent local copy of an already-installed WeChat app.

## Scope and safety

- Operate only on the user's own Mac and the WeChat app already installed there.
- Never download, upload, distribute, or commit any WeChat app bundle, installer, or generated .app file.
- Never read, copy, modify, or delete chats, messages, cookies, keychain items, login data, ~/Library/Containers, or other account data.
- Do not modify the original WeChat app. Create the copy under the user's personal ~/Applications folder.
- Do not use sudo and do not edit .zshrc or other shell startup files.
- Before the first local mutation, explain that the workflow copies the local app, changes only the copy's bundle identifier, locally re-signs the copy, and opens a new login window. Ask for confirmation unless the user has already clearly authorized execution.
- If the requested destination already exists, stop and ask for another app name. Never overwrite an existing clone.
- A new clone normally requires a QR scan for the second account. Do not promise passwordless login, preserved login sessions, or “no re-scan” behavior.

## Workflow

1. Confirm that the task is for macOS and that the user wants a local WeChat clone, not a downloaded app or a distributed app bundle.
2. Resolve this skill's root directory and use the bundled helper at <skill-root>/scripts/create-wechat-clone.sh. Do not execute a remote URL as a script.
3. Choose a unique clone name and bundle identifier. Defaults are 微信2.app and com.local.wechat.clone2. For another clone, use a different pair such as 微信3.app and com.local.wechat.clone3.
4. Tell the user what will happen, then run the helper with the system shell:

    /bin/zsh "<skill-root>/scripts/create-wechat-clone.sh"

    If automatic detection cannot find WeChat, pass the local app path explicitly:

    /bin/zsh "<skill-root>/scripts/create-wechat-clone.sh" "/Applications/微信.app" "微信2.app" "com.local.wechat.clone2"

5. Verify the reported destination exists and that the helper opened the clone. Tell the user to scan the second account's QR code; the original WeChat does not need to log out.
6. If the user asks how to launch it later, use Finder or:

    /usr/bin/open -n "$HOME/Applications/微信2.app"

## What the helper does

The helper looks for /Applications/微信.app or /Applications/WeChat.app, with a metadata search fallback. It then:

1. Creates ~/Applications if needed.
2. Copies the installed app with ditto.
3. Replaces only the clone's CFBundleIdentifier.
4. Applies an ad-hoc local signature with codesign.
5. Opens the clone with open -n.

It does not download WeChat, upload anything, access account data, or alter the original app.

## Troubleshooting

- If no app is found, ask the user to locate the installed WeChat app in Finder and provide its path.
- If the destination already exists, choose a new name and bundle identifier rather than deleting or overwriting it.
- If macOS blocks the clone, ask the user to use Finder's Open action once and review System Settings > Privacy & Security. Do not disable Gatekeeper or weaken unrelated security settings.
- If the original WeChat has been updated, create a fresh clone from the updated original instead of patching the old copy.
- If the shell reports a missing command, rerun with the absolute /bin/zsh path. Do not repair the problem by editing .zshrc or using sudo.
- If signing or launching fails, report the exact error and stop. Do not attempt to extract login data or bypass security controls.

## Optional icon customization

After the clone is created, the user can copy a square image in Preview, select 微信2.app in Finder, press Command-I, select the app icon in the Info window, and paste. This is optional and does not require changing the original app.
