# @wekor/react-native-local-network-permission

A React Native library for handling **iOS Local Network permission**, built on TurboModule architecture.

## Installation

```sh
npm install @wekor/react-native-local-network-permission
```

### Configure Info.plist

Add the following to your `ios/<YourApp>/Info.plist`:

```xml
<key>NSLocalNetworkUsageDescription</key>
<string>This app needs access to the local network to discover nearby devices.</string>

<key>NSBonjourServices</key>
<array>
    <string>_preflight_check._tcp</string>
</array>
```

- **`NSLocalNetworkUsageDescription`**: The message shown in the permission dialog. Customize it for your app.
- **`NSBonjourServices`**: Must include `_preflight_check._tcp` — the Bonjour service used internally by this library.

### Expo Setup

This library uses React Native TurboModule architecture. To use it in an Expo project:

1. Install the library.
2. Run `npx expo prebuild` to generate native projects.
3. Add the Info.plist keys via `app.json`:

```json
{
  "expo": {
    "ios": {
      "infoPlist": {
        "NSLocalNetworkUsageDescription": "This app needs local network access to detect nearby devices.",
        "NSBonjourServices": ["_preflight_check._tcp"]
      }
    }
  }
}
```

## Usage

```ts
import { requestPermission } from '@wekor/react-native-local-network-permission';

const granted = await requestPermission();
// true = granted, false = denied
```

## API

### `requestPermission(): Promise<boolean>`

Requests local network permission.

- **iOS 14+**: Triggers the NWBrowser/NWListener detection. Shows the system dialog on first call; returns current status on subsequent calls.
- **Android / other platforms**: Always returns `true` (local network access is unrestricted).

Returns `true` if granted, `false` if denied.

> **Why only one method?** Apple provides no API to silently query local network permission. Any detection attempt may trigger the system dialog, so separate "get" and "request" methods would be misleading.

## Platform Support

| Platform | Supported | Notes |
|----------|-----------|-------|
| iOS 14+  | Yes       | Full support via NWBrowser/NWListener |
| iOS < 14 | N/A       | Always returns `true` (no restriction) |
| Android  | N/A       | Always returns `true` |

## Limitations

- `requestPermission()` may show the system dialog on first call — this is an iOS limitation.
- iOS shows the dialog only once. Users must go to **Settings > Privacy & Security > Local Network** to change it.
- iOS 14+ only. Older versions return `true`.

## License

MIT
