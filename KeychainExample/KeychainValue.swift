
import Foundation

enum KeychainValueError: Error {
  case dataConvert
  case unexpectedError(status: OSStatus, description: String)
}

class KeychainValue: KeychainValueProtocol {
  func makeUnexpectedError(status: OSStatus) -> KeychainValueError {
    let desc = SecCopyErrorMessageString(status, nil) as String? ?? "Unknown keychain error"
    return .unexpectedError(status: status, description: desc)
  }
  
  func get(_ key: String) throws -> String? {
    var query = [String: Any]()
    query[kSecClass as String] = kSecClassGenericPassword
    query[kSecAttrAccount as String] = key
    query[kSecReturnData as String] = kCFBooleanTrue
    query[kSecMatchLimit as String] = kSecMatchLimitOne
        
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
    
  func set(_ key: String,value: String) throws {
      guard let data = value.data(using: .utf8) else {
          throw KeychainValueError.dataConvert
      }
      
      var query = [String: Any]()
      query[kSecClass as String] = kSecClassGenericPassword
      query[kSecAttrAccount as String] = key
//      query[kSecAttrService as String] = service
      
      // 指定されたキーがすでに存在する場合は、値を更新（上書き）する
      let updateAttributes = [kSecValueData as String: data]
      let status = SecItemUpdate(query as CFDictionary, updateAttributes as CFDictionary)
      
      // キーが存在しない場合は新規作成
      if status == errSecItemNotFound {
          query[kSecValueData as String] = data
          let addStatus = SecItemAdd(query as CFDictionary, nil)
          guard addStatus == errSecSuccess else {
              throw makeUnexpectedError(status: addStatus)
          }
      } else if status != errSecSuccess {
          throw makeUnexpectedError(status: status)
      }
  }
  
    
  func remove(_ key: String) throws {
    var query = [String: Any]()
    query[kSecClass as String] = kSecClassGenericPassword
    query[kSecAttrAccount as String] = key
        
    let status = SecItemDelete(query as CFDictionary)
    guard status == errSecSuccess || status == errSecItemNotFound else {
      throw makeUnexpectedError(status: status)
    }
  }
    
  func removeAll() throws {
    let query = [kSecClass as String: kSecClassGenericPassword]
        
    let status = SecItemDelete(query as CFDictionary)
    guard status == errSecSuccess || status == errSecItemNotFound else {
      throw makeUnexpectedError(status: status)
    }
  }
}
