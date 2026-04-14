/**
 * Default fallback (web and other platforms).
 * Always returns `true`.
 */
export async function requestPermission(): Promise<boolean> {
  return true;
}
