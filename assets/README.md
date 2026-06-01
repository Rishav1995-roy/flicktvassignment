# Assets

The current intro screen is **100% code-drawn** (the wallet, confetti, halftone
field and phone glyphs are all `CustomPainter` work), so the app ships with
**zero binary assets** and the smallest possible APK.

These folders are scaffolded so the product can grow without restructuring:

| Folder           | Use                                                        |
| ---------------- | ---------------------------------------------------------- |
| `assets/images/` | Raster art / illustrations (`@1x`, `@2x`, `@3x` variants). |
| `assets/icons/`  | App-specific vector/raster icons.                          |
| `assets/fonts/`  | Brand typeface (e.g. Okra / Inter) for a pixel-match.      |
| `assets/lottie/` | Reserved — **not used** (we keep to SDK-only animations).  |

To activate a folder, uncomment the matching entry in `pubspec.yaml` under
`flutter: assets:` (and `fonts:` for `assets/fonts/`). Empty folders are not
committed by Git on their own — keep a `.gitkeep` if you need the structure
before real files land.
