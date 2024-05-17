
import Foundation

enum KeychainValueError: Error {
  case dataConvert
  case unexpectedError(status: OSStatus, description: String)
}

public class KeychainValue: KeychainValueProtocol {
  private let service: String
  
  public init(service: String = Bundle.main.bundleIdentifier ?? "defaultService") {
    self.service = service
  }
  
  private func makeUnexpectedError(status: OSStatus) -> KeychainValueError {
    let desc = SecCopyErrorMessageString(status, nil) as String? ?? "Unknown keychain error"
    return .unexpectedError(status: status, description: desc)
  }
  
  public func get(_ key: String) throws -> String? {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: key,
      kSecMatchLimit as String: kSecMatchLimitOne,
      kSecReturnData as String: kCFBooleanTrue!
    ]
    
    var result: AnyObject?
    let status = SecItemCopyMatching(query as CFDictionary, &result)
        
    guard status == errSecSuccess else {
      if status == errSecItemNotFound {
        return nil
      } else {
        throw makeUnexpectedError(status: status)
      }
    }
        
    guard let data = result as? Data else {
      throw KeychainValueError.dataConvert
    }
        
    return String(data: data, encoding: .utf8)
  }
    
  public func set(_ key: String, value: String) throws {
    guard let data = value.data(using: .utf8) else {
      throw KeychainValueError.dataConvert
    }
      
    var query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: key
    ]
    
    let status = SecItemCopyMatching(query as CFDictionary, nil)
    if status == errSecItemNotFound {
      // Add new item
      query[kSecValueData as String] = value.data(using: .utf8)!
      let addStatus = SecItemAdd(query as CFDictionary, nil)
      guard addStatus == errSecSuccess else {
        throw makeUnexpectedError(status: addStatus)
      }
    }
    else if status == errSecSuccess {
      // Update existing item
      let attributes: [String: Any] = [kSecValueData as String: value.data(using: .utf8)!]
      let updateStatus = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
      guard updateStatus == errSecSuccess else {
        throw makeUnexpectedError(status: updateStatus)
      }
    }
    else {
      throw makeUnexpectedError(status: status)
    }
  }
  
  public func remove(_ key: String) throws {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: key
    ]
        
    let status = SecItemDelete(query as CFDictionary)
    guard status == errSecSuccess || status == errSecItemNotFound else {
      throw makeUnexpectedError(status: status)
    }
  }
    
  public func removeAll() throws {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service
    ]
        
    let status = SecItemDelete(query as CFDictionary)
    guard status == errSecSuccess || status == errSecItemNotFound else {
      throw makeUnexpectedError(status: status)
    }
  }
}
