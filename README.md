# SecurePacketEnvelope
SecurePacketEnvelope is a hybrid cryptosystem that encrypts user sensitive data efficiently and securely, supporting symmetric and asymmetric encryption algorithms. SecurePacketEnvelope uses AES256-CBC-PKCS7 and RSA-2048 by default.

It is created with UIKit, CommonCrypto, Combine.

How to run
SecurePacketEnvelope requires iOS 13.0 or later. If you are developer, you can set its deployment target to lower iOS version if needed.

If your XCode 12.0 is not available, you can change deployment target to lower iOS version.

Hybrid Encryption
Public-key ciphers (ie. RSA) are generally slow, inefficient, and have a plaintext size limit. Symmetric ciphers (ie. AES) require secure key exchange, which may not always be possible. Hybrid cryptosystems use both types of ciphers in tandem to efficiently encrypt plaintext, without requiring secure key exchange.

Features
No third-party dependencies
Lightweight implementation of AES256-CBC with automatic salt + IV randomization.
Cryptography logic derived from Apple's reliable CommonCrypto library

## License

SecurityKit is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
