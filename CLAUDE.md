# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

React Native TurboModule library (`@wekor/react-native-local-network-permission`) that detects iOS local network permission status using NWBrowser/NWListener. On Android and other platforms, it always returns `true`.

## Commands

- **Build:** `yarn prepare` (runs react-native-builder-bob)
- **Typecheck:** `yarn typecheck` (runs `tsc`)
- **Lint:** `yarn lint` (ESLint with flat config, `@react-native` + prettier)
- **Test:** `yarn test` (Jest with `@react-native/jest-preset`)
- **Run example app:** `yarn example start`, `yarn example ios`, `yarn example android`
- **Clean build output:** `yarn clean` (deletes `lib/`)

## Architecture

This is a **TurboModule** (not a Fabric component). Codegen spec is in `src/NativeLocalNetworkPermission.ts`.

### Platform resolution

`src/index.tsx` re-exports from `src/LocalNetworkPermission`, which resolves per-platform:
- `.ios.ts` — calls the native module via TurboModuleRegistry
- `.ts` — default fallback for Android, web, and other non-iOS platforms, returning `true`

### Native implementation (iOS only)

`ios/LocalNetworkPermission.mm` — Obj-C++ TurboModule. Creates a temporary NWListener advertising a Bonjour service (`_preflight_check._tcp`) and an NWBrowser looking for it. If the browser finds the listener, permission is granted; if either enters failed/waiting state, it's denied. Both are cleaned up after resolution.

The podspec (`LocalNetworkPermission.podspec`) links the `Network` framework.

### Build output

`react-native-builder-bob` compiles `src/` into `lib/` with two targets: ESM modules (`lib/module/`) and TypeScript declarations (`lib/typescript/`).

## Conventions

- Yarn 4 workspaces (root + `example/`)
- Commit messages follow Conventional Commits (enforced by commitlint via lefthook)
- Pre-commit hook runs ESLint and TypeScript checks on staged files
- Prettier config: single quotes, 2-space indent, es5 trailing commas
