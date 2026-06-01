# Blinkit Money - Flick TV Flutter Assignment

A pixel-faithful, cinematic recreation of the **Blinkit Money** wallet intro
screen, built with **only the Flutter SDK** - no third-party packages. Every flourish (the confetti burst, the tumbling 3D wallet, the staggered card cascade, the shimmer on the wordmark, the halftone glow) is hand-built from `AnimationController`, `CustomPainter`, `Tween`, `ShaderMask` and friends.

| | |
| | -- |
| **App name** | Rishav Deb Roy |
| **Package / applicationId** | `flicktv.rishavdebroy` |
| **Flutter** | `3.41.7` (stable) · pinned via **FVM** |
| **Dart** | `3.11.5` (Dart 3, sound null safety) |
| **Design system** | Material 3, dark, OTT-cinematic |
| **Third-party packages** | **None** (SDK-only, by requirement) |

## ✨ What it does

The screen plays a ~3.5s choreographed intro that matches the reference video:

1. A **confetti burst** erupts from behind the hero and rains down (gravity +
  sway + paper-flip tumble), fading as it falls.
2. The **3D wallet** (a gold pouch with a green lining and a white ₹ badge)
  **drops in from above**, tumbles with a damped-spring rotation, overshoots
   its scale, then settles into a perpetual **idle float + micro-wobble**.
3. The `**blinkit` / `MONEY`** wordmark rises, with a one-pass **light shimmer
  swept across `MONEY`.
4. The hero **promotes** from screen-centre toward the top, opening room as the
  three **benefit cards** cascade in (staggered fade + slide).
5. The **Add Money** CTA pops in, the **Claim Gift Card** row follows, the
  **settings** gear fades into the top bar, and a faint watermark settles in.

> Reduced-motion users get the final composed frame instantly (the timeline is
> snapped to its end), respecting `MediaQuery.disableAnimations`.

## 🚀 Quick start

### 1. Install FVM (Flutter Version Management)

```bash
# Recommended (Homebrew)
brew tap leoafarias/fvm
brew install fvm

# Or via Dart
dart pub global activate fvm
```

### 2. Install the pinned Flutter SDK

From the project root (the `.fvmrc` pins `3.41.7`):

```bash
fvm install            # downloads 3.41.7 if not already cached
fvm flutter --version  # sanity check
```

### 3. Get dependencies & run

```bash
fvm flutter pub get
fvm flutter run                 # on a connected device / emulator
```

> **Tip:** every Flutter command is prefixed with `fvm` so it uses the pinned
> SDK. In VS Code the bundled `.vscode/settings.json` already points the
> extension at `.fvm/flutter_sdk`, so `F5` "just works".

### 4. Run the tests

```bash
fvm flutter test
fvm flutter analyze       # zero issues expected
```

## 📦 Build the APK (for the deliverable)

```bash
# Universal release APK (simplest to share / sideload)
fvm flutter build apk --release

# Smaller, per-ABI APKs (recommended for real distribution)
fvm flutter build apk --release --split-per-abi

# App bundle (Play Store)
fvm flutter build appbundle --release
```

Output:

```
build/app/outputs/flutter-apk/app-release.apk
```

> The release build is signed with the debug keystore so `flutter run --release`
> and a quick sideload work out of the box. For store distribution, add a real
> `key.properties` + keystore (already git-ignored) and a `signingConfig`.

### Screen-recording tip

Record at 60fps. The intro is **deterministic** (driven by controllers, not by
scroll/gestures), so each take is identical — ideal for a clean capture. Launch
in **profile** mode for release-grade rendering while still seeing the perf
overlay:

```bash
fvm flutter run --profile
```

## 🧱 Architecture - feature-first, clean, scalable

```
lib/
├── main.dart                     # entry point: system chrome → runApp
├── app/
│   ├── app.dart                  # root MaterialApp (theme, routing, text-scale clamp)
│   └── router/
│       ├── app_routes.dart       # type-safe route names
│       └── app_router.dart       # onGenerateRoute + cinematic fade-through
├── core/                         # cross-feature, reusable, zero feature-knowledge
│   ├── constants/                # durations, spacing (single source of truth)
│   ├── theme/                    # colors, gradients, text styles, ThemeData (M3 dark)
│   ├── extensions/               # BuildContext & num ergonomics
│   ├── utils/                    # custom curves + the stagger/timeline engine
│   ├── animations/               # reusable FadeSlideIn, Pressable
│   └── widgets/                  # CircleIconButton, PrimaryButton
└── features/
    └── home/
        └── presentation/
            ├── screens/          # BlinkitMoneyScreen (orchestrator)
            ├── controllers/      # IntroChoreography (the timeline, as data)
            ├── widgets/          # WalletBadge, BrandLockup, ConfettiLayer, …
            ├── painters/         # WalletPainter, ConfettiPainter, HalftonePainter…
            └── models/           # MoneyFeature, ConfettiParticle (pure data)
```

### Why this shape?

- **Feature-first**, not layer-first. Everything about "home" lives under
`features/home`, so the unit of ownership is a *feature*, not a horizontal
slice. Adding "wallet detail" or "transactions" means a new sibling folder,
never a sprawling edit across `screens/`, `widgets/`, `models/`.
- `**core/` knows nothing about features.* It only ever flows *downhill
(features depend on core, never the reverse). This keeps it a genuinely
reusable foundation and prevents circular coupling.
- **Presentation is split by responsibility:** `screens` orchestrate,
`widgets` render, `painters` draw pixels, `controllers` hold timing/logic,
`models` are immutable data. A widget never owns business logic; the screen
never draws pixels.
- **Relative imports within the package** (enforced by lint) keep modules
movable.

## 🎬 Animation architecture - the heart of the project

### One timeline to rule them all

The entire entrance is driven by a **single** `AnimationController` (`_intro`).
Each element owns an `IntervalSegment` - a `(begin, end, curve)` slice of that 0→1 master timeline - declared as **data** in `IntroChoreography`:

```dart
static const IntervalSegment wallet = IntervalSegment(0.00, 0.42, curve: AppCurves.silk);
static const IntervalSegment money  = IntervalSegment(0.36, 0.56, curve: AppCurves.silk);
static List<IntervalSegment> get cards => staggered(count: 3, start: 0.50, end: 0.86);
```

**Why one controller instead of many?**

- **Frame-locked sync** - every element reads the same clock, so overlaps and hand-offs are exact and never drift.
- **One rebuild source** - fewer tickers, less overhead, trivially disposed.
- **Re-tunable in one file** - the whole rhythm of the product lives in `IntroChoreography`; you can re-time the sequence without touching widgets.

Two *additional* controllers exist only because they have genuinely independent
lifecycles:

| Controller | Lifecycle | Drives |
| -- | | |
| `_intro` | one-shot `forward` | every entrance (via `IntervalSegment`s) |
| `_confetti` | one-shot `forward` | the particle burst (longer tail) |
| `_ambient` | `repeat(reverse:)` | the wallet's perpetual float + wobble |

### Implicit **and** explicit, used deliberately

- **Explicit** (`AnimationController` + `AnimatedBuilder`) for the choreography and the painters - we need precise, deterministic, multi-property control.
- **Implicit** (`AnimatedScale` via `Pressable`, implicit color/opacity) for
*interaction* feedback, where "animate to the new value" is exactly right.

### SDK techniques on display

`AnimationController` · `Tween` · `CurvedAnimation` · `Interval` ·
`AnimatedBuilder` · `Opacity`/`AnimatedOpacity` · `ScaleTransition` ·
`Transform` (translate/rotate/scale) · `ShaderMask` (the `MONEY` shimmer) ·
`CustomPainter` (wallet, confetti, halftone, phone glyphs) · `RepaintBoundary`
isolation · custom `Curve`s (`DampedWobbleCurve`, `overshoot`, `silk`) · a
custom `PageRouteBuilder` transition.

### Custom curves (no physics package needed)

`DampedWobbleCurve` is a hand-rolled critically-damped oscillation
(`1 − e^(−kt)·cos(nπt)`) that gives the wallet its believable "tumble in, then
quiver to rest" without reaching for any dependency.

## ⚡ Performance - engineered for a locked 60fps

| Technique | Where | Payoff |
| | | -- |
| **Single master ticker** | `IntroChoreography` + `_intro` | minimal vsync overhead, no drift |
| `**RepaintBoundary` isolation** | confetti, background, glyph tiles | heavy repaints never invalidate the tree |
| **Static painters return `shouldRepaint:false`** | wallet, halftone | painted once, then cached as a layer |
| `**child:`hoisting in`AnimatedBuilder**`      | every animated widget                      | the subtree is built once; only the cheap`Transform`/`Opacity` shell rebuilds each frame |
| **Pre-computed, seeded particles** | `ConfettiParticle.burst` | zero per-frame allocation on the hot path; reproducible recordings |
| `**const`everywhere**                           | whole codebase (lint-enforced)             | const widgets are canonicalised and skip rebuilds                                         |
| **Scoped rebuilds**                              | promote animation lives in`\_IntroContent`| the`Scaffold`never rebuilds during the intro                                            |
|`**IgnorePointer` on decorative layers** | confetti, watermark | no wasted hit-testing |
| **Text-scale clamp** | `app.dart` | layout can't break under extreme accessibility scaling |

**How to verify:** run `--profile`, open DevTools → Performance, and confirm the
raster + UI threads stay under the 16.6ms budget. The `WalletPainter` and
`HalftonePainter` should show **no** repaints after first paint; only
`ConfettiPainter` repaints during the burst (by design, and isolated).

## 🎨 Design system

- **Colours** (`AppColors`) are semantic (`background`, `card`, `textPrimary`)
*and* concrete (`walletGold`, `blinkitGreen`) - widgets prefer roles so a re-theme touches one file.
- **Gradients** (`AppGradients`) are declared `const` once (page backdrop, top glow, CTA, wallet body/lining) - no per-build allocation.
- **Typography** (`AppTextStyles`) is a small scale; `fontFamily` is a single
switch to pixel-match with a bundled face (see `pubspec.yaml`).
- **Spacing & motion** (`AppSpacing`, `AppDurations`) replace magic numbers, so
rhythm and tempo are tunable centrally.

## ✅ Code-quality bar

- Strict analyzer (`strict-casts/inference/raw-types`) + a tightened lint set on
top of `flutter_lints`; a few correctness lints are **errors**.
- `fvm flutter analyze` → **0 issues**. `fvm flutter test` → **green**.
- Documentation comments explain the *why*, not the *what*.
- Every `AnimationController` is disposed; no leaked tickers.
- No `print`, no `BuildContext`-across-async hazards (lint-guarded).

## 🗺️ Implementation strategy & step-by-step plan

The project was built in vertical, reviewable slices:

1. **Scaffold** - `fvm flutter create` (org `flicktv`, project `rishavdebroy`),
  pin SDK, set the display name to *Rishav Deb Roy*.
2. **Core foundation** - constants, M3 dark theme, gradients, text styles,
  extensions, the stagger/timeline engine, custom curves, reusable
   `FadeSlideIn` / `Pressable`, base buttons.
3. **App shell** - thin `MaterialApp`, named routes, fade-through transition,
  edge-to-edge system chrome.
4. **Painters first** (the hard pixels) - wallet, confetti, halftone, phone
  glyphs - each independently verifiable.
5. **Feature widgets** - wallet badge (entrance + idle), brand lockup (shimmer),
  confetti layer, feature cards/list, gift tile, watermark, top bar.
6. **Orchestration** - `IntroChoreography` (timing as data) + the
  `BlinkitMoneyScreen` that wires three controllers and the promote layout.
7. **Validate** - analyze, widget tests, golden-eyeballing the layout, tune
  spacing for a clean fit, build the APK.

## 🌿 Git & branching strategy

A trunk-based flow with short-lived, conventional-commit feature branches:

```
main                      # always green, always shippable
  └── feat/project-setup           # FVM, scaffold, configs
  └── feat/core-design-system      # theme, constants, extensions
  └── feat/animation-engine        # curves, stagger, reusable motion
  └── feat/wallet-painter          # the 3D wallet
  └── feat/confetti-system         # particles + painter
  └── feat/home-screen             # orchestration + layout
  └── chore/docs-and-ci            # README, lints, tests
```

**Suggested commit sequence** (Conventional Commits):

```
chore: scaffold project with FVM (Flutter 3.41.7) and set app identity
feat(core): add M3 dark theme, color/gradient/typography system
feat(core): add timeline/stagger engine and custom curves
feat(core): add reusable FadeSlideIn, Pressable and base buttons
feat(home): paint the 3D wallet, halftone background and phone glyphs
feat(home): add gravity-driven confetti burst system
feat(home): orchestrate intro choreography on a single master timeline
test: add smoke + content widget tests
chore: tighten lints, add VS Code config and docs
```

## 🔍 Performance optimisation checklist

- One master `AnimationController` for the choreography
- All controllers disposed in `dispose()`
- `RepaintBoundary` around every per-frame painter
- Static painters return `shouldRepaint: false`
- `child:` hoisted out of every `AnimatedBuilder`
- Particles pre-computed & seeded (no hot-path allocation)
- `const` constructors everywhere (lint-enforced)
- Decorative layers wrapped in `IgnorePointer`
- Rebuilds scoped (the `Scaffold` doesn't rebuild during the intro)
- `reduce-motion` honoured
- Verified on profile build (UI + raster under 16.6ms)

## 🏁 Final polish checklist

- Matches the reference: confetti, wallet tumble, brand reveal, card
cascade, CTA, gift row, settings gear, watermark
- Edge-to-edge, dark status-bar icons, portrait-locked
- Responsive: hero scales on compact heights; layout fits phone classes
- Text-scale clamped so accessibility can't break the cinematic layout
- `flutter analyze` clean · tests green
- App name **Rishav Deb Roy**, id `flicktv.rishavdebroy`
- Zero third-party packages
- APK build verified

## 🧭 Project conventions

- **Imports:** relative within `lib/`, `package:` for SDK/Flutter.
- **Naming:** `*_screen`, `*_painter`, `*_card`; `AppXxx` for design tokens.
- **No business logic in widgets** - timing lives in `controllers/`, data in
`models/`.
- **One widget, one responsibility** - orchestrate / render / draw / hold data.

*Built by **Rishav Deb Roy** for the Flick TV Flutter assignment - SDK-only, animation-first, production-minded.*