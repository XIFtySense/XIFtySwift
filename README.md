# XIFtySwift

Swift package for XIFty.

This package currently builds against the XIFty core repository through the
stable `xifty-ffi` C ABI. Local development expects a sibling checkout of the
core repo at:

- `../XIFty`

You can override that location with `XIFTY_CORE_DIR`.

## Local Development

```bash
swift test
```

With a custom core checkout path:

```bash
XIFTY_CORE_DIR=/path/to/XIFty swift test
```

## Architecture

- package manager: Swift Package Manager
- C interop target: `CXIFty`
- core seam: `xifty-ffi`
- exchange format: JSON strings decoded with `Foundation`

## Status

This repo is public package infrastructure, but the core XIFty engine remains
private today. Until the core distribution story is finalized, the package links
against a local XIFty checkout instead of a published binary artifact.

