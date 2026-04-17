import XCTest
@testable import XIFtySwift

final class XIFtySwiftTests: XCTestCase {
    private var root: URL {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
    }

    private var fixture: String {
        root.appendingPathComponent("fixtures/happy.jpg").path
    }

    private func fieldsByName(_ output: [String: Any]) throws -> [String: [String: Any]] {
        let normalized = try XCTUnwrap(output["normalized"] as? [String: Any])
        let fields = try XCTUnwrap(normalized["fields"] as? [[String: Any]])
        var byName: [String: [String: Any]] = [:]
        for field in fields {
            byName[field["field"] as! String] = field
        }
        return byName
    }

    func testVersionLooksSemantic() {
        XCTAssertTrue(XIFty.version().contains("."))
    }

    func testProbeReturnsInputSummary() throws {
        let output = try XIFty.probe(path: fixture)
        let input = try XCTUnwrap(output["input"] as? [String: Any])
        XCTAssertEqual(output["schema_version"] as? String, "0.1.0")
        XCTAssertEqual(input["detected_format"] as? String, "jpeg")
        XCTAssertEqual(input["container"] as? String, "jpeg")
    }

    func testExtractDefaultsToFullEnvelope() throws {
        let output = try XIFty.extract(path: fixture)
        XCTAssertNotNil(output["raw"])
        XCTAssertNotNil(output["interpreted"])
        XCTAssertNotNil(output["normalized"])
        XCTAssertNotNil(output["report"])
    }

    func testRawViewPreservesMetadataEvidence() throws {
        let output = try XIFty.extract(path: fixture, view: .raw)
        let raw = try XCTUnwrap(output["raw"] as? [String: Any])
        let containers = try XCTUnwrap(raw["containers"] as? [[String: Any]])
        let metadata = try XCTUnwrap(raw["metadata"] as? [[String: Any]])
        XCTAssertEqual(containers.first?["label"] as? String, "jpeg")
        XCTAssertEqual(metadata.first?["tag_name"] as? String, "ImageWidth")
    }

    func testInterpretedViewExposesDecodedTags() throws {
        let output = try XIFty.extract(path: fixture, view: .interpreted)
        let interpreted = try XCTUnwrap(output["interpreted"] as? [String: Any])
        let metadata = try XCTUnwrap(interpreted["metadata"] as? [[String: Any]])
        let tagNames = metadata.compactMap { $0["tag_name"] as? String }
        XCTAssertTrue(tagNames.contains("Make"))
        XCTAssertTrue(tagNames.contains("Model"))
        XCTAssertTrue(tagNames.contains("DateTimeOriginal"))
    }

    func testNormalizedViewReturnsExpectedFields() throws {
        let output = try XIFty.extract(path: fixture, view: .normalized)
        let fields = try fieldsByName(output)
        XCTAssertEqual((fields["captured_at"]?["value"] as? [String: Any])?["value"] as? String, "2024-04-16T12:34:56")
        XCTAssertEqual((fields["device.make"]?["value"] as? [String: Any])?["value"] as? String, "XIFtyCam")
        XCTAssertEqual((fields["device.model"]?["value"] as? [String: Any])?["value"] as? String, "IterationOne")
        XCTAssertEqual((fields["software"]?["value"] as? [String: Any])?["value"] as? String, "XIFtyTestGen")
    }

    func testReportViewStaysExplicitWhenEmpty() throws {
        let output = try XIFty.extract(path: fixture, view: .report)
        let report = try XCTUnwrap(output["report"] as? [String: Any])
        XCTAssertEqual((report["issues"] as? [Any])?.count, 0)
        XCTAssertEqual((report["conflicts"] as? [Any])?.count, 0)
        XCTAssertNil(output["normalized"])
    }
}
