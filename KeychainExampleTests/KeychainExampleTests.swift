@testable import KeychainExample
import XCTest

final class KeychainExampleTests: XCTestCase {
  var keychain: KeychainValue!

  override func setUpWithError() throws {
    keychain = KeychainValue(service: "testService")
    try keychain.removeAll()
  }

  override func tearDownWithError() throws {
    keychain = nil
  }

  func testSetGet() throws {
    try keychain.set("testkey", value: "12345")
    let val = try keychain.get("testkey")
    XCTAssertEqual(val, "12345")
  }

  func testInsertUpdate() throws {
    let keychain = KeychainValue()

    try keychain.set("myKey", value: "12345")
    let newVal = try keychain.get("myKey")
    XCTAssertEqual(newVal, "12345")

    try keychain.set("myKey", value: "67890")
    let updatedVal = try keychain.get("myKey")
    XCTAssertEqual(updatedVal, "67890")
  }

  func testInsertDelete() throws {
    let keychain = KeychainValue()

    try keychain.set("myKey", value: "12345")
    let newVal = try keychain.get("myKey")
    XCTAssertEqual(newVal, "12345")

    try keychain.set("myKey2", value: "67890")
    let myKey2Val = try keychain.get("myKey2")
    XCTAssertEqual(myKey2Val, "67890")

    try keychain.remove("myKey")
    let deletedVau = try keychain.get("myKey")
    XCTAssertNil(deletedVau)

    let remainVal = try keychain.get("myKey2")
    XCTAssertEqual(remainVal, "67890")
  }

  func testInsertRemoveAll() throws {
    let keychain = KeychainValue()

    for keyid in 0...10 {
      try keychain.set("myKey\(keyid)", value: "val\(keyid)")
    }

    try keychain.removeAll()

    for keyid in 0...10 {
      let val = try keychain.get("myKey\(keyid)")
      XCTAssertNil(val)
    }
  }
}
