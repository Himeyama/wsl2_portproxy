# WSL2_PORTPROXY

## 概要

GUIでWSL2のポートフォワーディングの設定をするツール

## 注意事項
WSL2 は毎回 IP アドレスを変更する仕様なので、起動時に IP アドレスが変更されている場合、異なる IP アドレスの項目は削除される仕様です。
そのため、WSL2 以外の用途でポートフォワードを行う場合はこのツールを使用しないでください。

## インストール方法 & 実行

1. [Releases](https://github.com/Himeyama/wsl2_portproxy/releases) で `wsl2_portproxy.zip` をダウンロードし解凍する。
1. `install.ps1`を右クリックし、「PowerShell で実行」をクリックする。
1. 管理者権限で PowerShell を開き、`wsl2_portproxy`を実行する。

![](screenshot.png)

## 補足1
PowerShell を管理者権限で開くには、画面左下の Windows マークを右クリックし、
Windows PowerShell (管理者) をクリックして開くことができる。

## 補足2
ポリシーが何とかで動かないときは以下を実行。
```ps1
Set-ExecutionPolicy Unrestricted
```
