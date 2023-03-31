![GitHub Cards Preview](https://user-images.githubusercontent.com/24524023/229168910-eba2e77b-5f2d-4038-9ddf-c00aef14f043.png?raw=true)
# SecurePacketEnvelope
SecurePacketEnvelope is a hybrid cryptosystem that encrypts user sensitive data efficiently and securely, supporting symmetric and asymmetric encryption algorithms. SecurePacketEnvelope uses AES256-CBC-PKCS7 and RSA-2048 by default.

It is created with UIKit, CommonCrypto, Combine.

### How to run
SecurePacketEnvelope requires iOS 13.0 or later. If you are developer, you can set its deployment target to lower iOS version if needed.

### Hybrid Encryption
Public-key ciphers (ie. RSA) are generally slow, inefficient, and have a plaintext size limit. Symmetric ciphers (ie. AES) require secure key exchange, which may not always be possible. Hybrid cryptosystems use both types of ciphers in tandem to efficiently encrypt plaintext, without requiring secure key exchange.

### Features
* No third-party dependencies
* Lightweight implementation of AES256-CBC with generated Random Key + IV.
* Cryptography logic derived from Apple's reliable CommonCrypto library

## Usage
I have explained about SecurePacketEnvelope in the form of a post on Medium.

https://medium.com/@mehran.kmlf/build-a-secure-envelope-in-ios-swift-f1f0297d2562

## License

SecurePacketEnvelope is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
