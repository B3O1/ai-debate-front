## iOS signing

1. Copy `ios/Flutter/Signing.xcconfig.example` to `ios/Flutter/Signing.xcconfig`.
2. Replace `YOUR_TEAM_ID` with your Apple Developer Team ID.
3. Open the iOS project in Xcode and confirm:
   - Runner target uses team signing
   - Bundle Identifier is `com.b3o1.aitalk`
   - Display Name is `AI TalK`
4. Build once on a real device or archive to let Xcode refresh provisioning.
