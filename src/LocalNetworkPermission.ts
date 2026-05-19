/**
 * Default fallback for Android, web, and other non-iOS platforms.
 * Always returns `true` since only iOS gates local network access.
 */
export async function requestPermission(): Promise<boolean> {
  return true;
}
