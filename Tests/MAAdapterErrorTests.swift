@testable import VoodooMaxAdapter
import XCTest
import XCTestToolKit

final class MAAdapterErrorTests: XCTestCase {
    func test_ad_display_error_with_string() throws {
        let error = MAAdapterError.adDisplay("test error")
    }
}
