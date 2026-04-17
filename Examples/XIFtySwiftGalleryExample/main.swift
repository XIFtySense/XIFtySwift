import Foundation
import XIFtySwift

let fixture = URL(fileURLWithPath: #filePath)
    .deletingLastPathComponent()
    .deletingLastPathComponent()
    .deletingLastPathComponent()
    .appendingPathComponent("fixtures/happy.jpg")

let output = try XIFty.extract(path: fixture.path, view: .normalized)
let normalized = output["normalized"] as! [String: Any]
let fields = normalized["fields"] as! [[String: Any]]

func value(_ fields: [[String: Any]], for name: String) -> Any? {
    fields.first { ($0["field"] as? String) == name }
        .flatMap { $0["value"] as? [String: Any] }?["value"]
}

let asset: [String: Any] = [
    "sourcePath": fixture.path,
    "format": (output["input"] as! [String: Any])["detected_format"]!,
    "capturedAt": value(fields, for: "captured_at") as Any,
    "cameraMake": value(fields, for: "device.make") as Any,
    "cameraModel": value(fields, for: "device.model") as Any,
    "width": value(fields, for: "dimensions.width") as Any,
    "height": value(fields, for: "dimensions.height") as Any,
    "software": value(fields, for: "software") as Any,
]

print(String(data: try JSONSerialization.data(withJSONObject: asset, options: [.prettyPrinted]), encoding: .utf8)!)
