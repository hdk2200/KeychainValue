//
// Copyright (c) 2024, ___ORGANIZATIONNAME___ All rights reserved.
//
//

import XCTest
@testable import KeychainExample


final class KeychainExampleTests: XCTestCase {
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testGet() throws {
    let keychain = KeychainValue()

    try keychain.set("testkey", value: "12345")
    let val = try keychain.get("testkey")
    XCTAssertEqual(val, "12345")
  }
}
