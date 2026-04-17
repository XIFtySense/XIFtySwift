# XIFtySwift

Swift package for [XIFty](https://github.com/XIFtySense/XIFty).

`XIFtySwift` is a SwiftPM wrapper over the stable `xifty-ffi` C ABI. It is
ready for source-based use today and is intended to become the canonical Swift
package for XIFty consumers.

## What You Get

- `XIFty.version()`
- `XIFty.probe(path:)`
- `XIFty.extract(path:view:)`
- a Foundation-based Swift wrapper over the core JSON contract

## Quickstart

Clone the public core repo as a sibling checkout, then run the package against
it:

```bash
git clone git@github.com:XIFtySense/XIFty.git ../XIFty
swift test
```

With a custom core checkout path:

```bash
XIFTY_CORE_DIR=/path/to/XIFty swift test
```

To consume the package from SwiftPM once you are pinning tagged releases:

```swift
.package(url: "https://github.com/XIFtySense/XIFtySwift.git", from: "0.1.0")
```

## Architecture

- package manager: Swift Package Manager
- C interop target: `CXIFty`
- core seam: `xifty-ffi`
- exchange format: JSON strings decoded with `Foundation`

## Status

- source-first and usable today
- built on the stable `xifty-ffi` ABI
- CI validates the wrapper against the public XIFty core repo on every push
- prepared for future Swift package distribution hardening

## Release Model

- SwiftPM distribution is tag-driven
- consumers should depend on semver tags, not branch heads
- the stable dependency seam remains `xifty-ffi`, with `CXIFty` as the C bridge

## License

MIT
