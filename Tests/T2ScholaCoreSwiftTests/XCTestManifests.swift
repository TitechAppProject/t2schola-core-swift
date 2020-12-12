import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(T2ScholaCoreSwiftTests.allTests),
    ]
}
#endif
