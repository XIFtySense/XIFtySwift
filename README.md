# XIFty for Swift

`XIFtySwift` is the official Swift binding repo for XIFty.

It provides a Foundation-friendly Swift wrapper over the stable `xifty-ffi` ABI
so Swift applications can probe files and extract XIFty metadata views without
dropping to the raw C surface.

## What It Does

XIFty exposes four complementary metadata views:

- `raw`
- `interpreted`
- `normalized`
- `report`

This Swift package keeps those views intact and adds a small Swift API.

## Quick Example

```swift
let output = try XIFty.extract(path: "photo.jpg", view: .normalized)
let normalized = output["normalized"] as! [String: Any]
```

## API

- `XIFty.version()`
- `XIFty.probe(path:)`
- `XIFty.extract(path:view:)`

## Why Use It

Use this binding when you want:

- native Swift access to XIFty
- normalized metadata fields for application logic
- raw and interpreted metadata for provenance-sensitive workflows
- a narrow Swift wrapper over the stable ABI instead of shelling out to a CLI

## Local Setup

This repo no longer assumes a sibling `../XIFty` checkout.

Prepare the core dependency into a repo-local cache:

```bash
bash scripts/prepare-core.sh
```

Then run the package:

```bash
swift test
swift run XIFtySwiftExample
swift run XIFtySwiftGalleryExample
```

You can still override the core location explicitly with `XIFTY_CORE_DIR`.

This binding is intentionally not yet on the canonical runtime-artifact path
used by the newer Python and Rust packaging work. Swift remains a source-first
binding until that distribution story is hardened more deliberately.

## Status

- source-first and usable today
- not yet on the canonical runtime-artifact packaging path
- built on the stable `xifty-ffi` ABI
- CI validates the wrapper against the public XIFty core repo

## License

MIT
