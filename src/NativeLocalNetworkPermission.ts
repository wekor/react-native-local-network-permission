import { TurboModuleRegistry, type TurboModule } from 'react-native';

/**
 * Native module spec for codegen.
 *
 * The return type uses inline object shapes because TurboModule codegen
 * does not support importing custom TypeScript types.
 */
export interface Spec extends TurboModule {
  /**
   * Request (or check) local network permission.
   * On iOS this uses the NWBrowser/NWListener trick and may trigger the
   * system permission dialog if the user has not yet made a choice.
   *
   * Resolves with `true` if granted, `false` if denied.
   */
  requestPermission(): Promise<boolean>;
}

export default TurboModuleRegistry.getEnforcing<Spec>(
  'LocalNetworkPermission'
);
