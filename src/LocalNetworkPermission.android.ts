/**
 * Android does not restrict local network access.
 * Always returns `true`.
 */
export async function requestPermission(): Promise<boolean> {
  return true;
}
