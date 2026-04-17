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

print("XIFty version: \(XIFty.version())")
print("Detected format: \((output["input"] as! [String: Any])["detected_format"]!)")
print("Camera: \(value(fields, for: "device.make")!) \(value(fields, for: "device.model")!)")
print("Captured at: \(value(fields, for: "captured_at")!)")
print("Dimensions: \(value(fields, for: "dimensions.width")!)x\(value(fields, for: "dimensions.height")!)")
print(String(data: try JSONSerialization.data(withJSONObject: output, options: [.prettyPrinted]), encoding: .utf8)!)
