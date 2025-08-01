//
//  README.md
//  Opus
//
//  Created by lynn on 2025/8/4.
//
## 以下是智能生成的文档，谨慎使用，这个库主要解决其他opus库在SwiftUI里xcode打开模拟器报错的问题！！！
# 🎧 Opus

Swift Package for [`libopus`](https://opus-codec.org/) and custom Ogg/Opus handling, supporting iOS, macOS, and iOS Simulator via `xcframework`.

---

## 📦 仓库地址

GitHub: [https://github.com/uuneo/Opus](https://github.com/uuneo/Opus)

---

## 📁 项目结构

```
.
├── build-opus-xcframework.sh      # 自动构建 opus xcframework 的脚本
├── Package.swift                  # Swift Package 描述文件
└── Sources
    ├── libopus                    # libopus 静态链接库封装（xcframework）
    │   └── libopus.xcframework
    │       ├── ios-arm64
    │       ├── ios-arm64_x86_64-simulator
    │       └── macos-arm64_x86_64
    └── Opus                       # 自定义封装与 Ogg/Opus 处理逻辑
        ├── DataItem.m
        ├── include/               # 公共头文件
        ├── ogg/                   # Ogg bitstream 解析实现
        ├── opusenc/               # 编码器模块
        └── opusfile/              # 解码器模块
```

---

## ✅ 特性

- 支持 `iOS`、`iOS Simulator` 和 `macOS`
- 使用 `xcframework` 静态封装 `libopus.a`
- 支持 Ogg 容器封装、Opus 编解码
- 可在 Swift 或 Objective-C 项目中使用

---

## 🧩 安装方法

### 使用 Swift Package Manager (SPM)

在 Xcode 中添加依赖：

```
https://github.com/uuneo/Opus
```

或在你的 `Package.swift` 中添加：

```swift
.package(url: "https://github.com/uuneo/Opus", from: "1.0.0"),
```

添加依赖到你的 target：

```swift
.target(
    name: "YourApp",
    dependencies: [
        .product(name: "libopus", package: "Opus"),
        .product(name: "Opus", package: "Opus"),
    ]
)
```

---

## 🚀 使用示例

### Swift 中使用：

```swift
import libopus
import Opus

let writer = OggOpusWriter()
// writer.begin(with: ...)
// writer.writeFrame(...)
```

### Objective-C 中使用：

```objc
#import "opus.h"
#import "OggOpusWriter.h"
```

---

## 🏗️ 手动构建 `libopus.xcframework`

1. 下载 [libopus](https://opus-codec.org/downloads/) 源码并解压到项目根目录（确保与 `build-opus-xcframework.sh` 同级）
2. 运行脚本：

```bash
chmod +x build-opus-xcframework.sh
./build-opus-xcframework.sh
```

构建完成后，生成的 `libopus.xcframework` 位于：

```
Sources/libopus/libopus.xcframework
```

---

## 🧾 License

- `libopus` 由 [Xiph.Org Foundation](https://xiph.org/) 提供，使用 **BSD License**
- 本 Swift 包和封装代码基于 **MIT License**

---

## 🙌 Credits

- [libopus](https://opus-codec.org/)
- 封装与适配：[@uuneo](https://github.com/uuneo)
