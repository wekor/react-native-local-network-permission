import NativeModule from './NativeLocalNetworkPermission';

/**
 * Request / check local network permission on iOS.
 *
 * On iOS 14+, this triggers the NWBrowser/NWListener detection mechanism:
 * - If the user has not yet made a choice, the system permission dialog will appear.
 * - If permission has already been granted or denied, the current status is returned
 *   without showing a dialog.
 *
 * @returns `true` if granted, `false` if denied.
 */
export async function requestPermission(): Promise<boolean> {
  return NativeModule.requestPermission();
}
