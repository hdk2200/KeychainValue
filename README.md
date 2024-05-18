# KeychainValue

## Overview

This Swift class provides functionalities to interact with the keychain, enabling secure storage and retrieval of sensitive information such as passwords, tokens, or cryptographic keys.

## Features

- **Initialization**: The `KeychainValue` class can be initialized with a custom service identifier. If not provided, it defaults to the bundle identifier of the main application.
  
- **Get Value**: The `get(_:)` method retrieves a string value from the keychain associated with the specified key.
  
- **Set Value**: The `set(_:value:)` method stores a string value in the keychain associated with the specified key. If the key already exists, the value is updated; otherwise, a new entry is created.
  
- **Remove Value**: The `remove(_:)` method removes the entry corresponding to the specified key from the keychain.
  
- **Remove All Values**: The `removeAll()` method removes all entries associated with the service from the keychain.

## Usage Example

```swift
let keychain = KeychainValue()

// Set a value
do {
    try keychain.set("username", value: "john_doe")
} catch {
    print("Error setting value in keychain: \(error)")
}

// Retrieve a value
do {
    if let username = try keychain.get("username") {
        print("Username: \(username)")
    } else {
        print("No value found for key 'username'")
    }
} catch {
    print("Error retrieving value from keychain: \(error)")
}

// Remove a value
do {
    try keychain.remove("username")
} catch {
    print("Error removing value from keychain: \(error)")
}

// Remove all values
do {
    try keychain.removeAll()
} catch {
    print("Error removing all values from keychain: \(error)")
}
