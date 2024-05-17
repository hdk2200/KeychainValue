import Foundation

public protocol KeychainValueProtocol {
  func get(_ key: String) throws -> String?
  func set(_ key: String, value: String) throws
  func remove(_ key: String) throws
  func removeAll() throws
}
