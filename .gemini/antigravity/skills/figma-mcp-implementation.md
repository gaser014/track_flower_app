# Figma MCP Implementation Guide

## Overview

This skill documents the exact workflow for implementing Figma designs into this Flutter project using the local Figma MCP server. Follow every step in order — skipping steps causes visual drift or broken code.

---

## Prerequisites

### 1. MCP Server Must Be Running

The local Figma Desktop MCP server runs at `http://localhost:3845/mcp`.

Workspace config is at `.kiro/settings/mcp.json`:

```json
{
  "mcpServers": {
    "figma": {
      "url": "http://localhost:3845/mcp",
      "disabled": false,
      "autoApprove": [
        "get_design_context",
        "get_metadata",
        "get_screenshot",
        "get_variable_defs",
        "get_figma_data",
        "download_figma_images"
      ],
      "disabledTools": []
    }
  }
}
```

If the server is not connected, create or update this file and restart Kiro.

### 2. Figma File Must Be Open in Figma Desktop

The MCP server reads from the currently open Figma file. The file must be open and the correct frame/component selected or referenced by node ID.

---

## Step-by-Step Workflow

### Step 1: Extract Node ID from URL

Given a Figma URL like:
```
https://www.figma.com/design/4BF7msiybooQdIfUc2tLTe/Darsy-Design-v01?node-id=194-1258&m=dev
```

- **File key**: `4BF7msiybooQdIfUc2tLTe`
- **Node ID**: `194-1258` → pass as `194:1258` (replace `-` with `:`)

### Step 2: Fetch Design Context + Screenshot in Parallel

Always call both tools simultaneously:

```
get_design_context(nodeId: "194:1258", clientFrameworks: "flutter", clientLanguages: "dart", artifactType: "WEB_PAGE_OR_APP_SCREEN", taskType: "CREATE_ARTIFACT")

get_screenshot(nodeId: "194:1258")
```

**If `get_design_context` returns a Code Connect prompt** ("Some Figma design components are not connected..."):
- Answer **no** to Code Connect mapping
- Call `get_design_context` again with `forceCode: true`

**If the response is truncated** (design too complex):
1. Call `get_metadata(nodeId: "194:1258")` to get the node tree
2. Identify child node IDs for each major section
3. Call `get_design_context` on each child node individually

### Step 3: Read the Screenshot

The screenshot tool returns an image. Always use it as the **source of truth** for:
- Layout proportions
- Spacing between elements
- Visual states (selected, unselected, hover)
- Color accuracy

### Step 4: Map Figma Tokens to Project Tokens

| Figma value | Project token |
|---|---|
| `#F9F8F6` | `AppColors.fillLTC8SG` |
| `#F8FAFC` | `AppColors.neutralBackground` |
| `#FFFFFF` | `AppColors.white` / `AppColors.neutralCards` |
| `#0F172A` | `AppColors.neutralDark` |
| `#334155` | `AppColors.fillBE8Q2J` |
| `#94A3B8` | `AppColors.neutralHint` |
| `#E2E8F0` | `AppColors.neutralBorder` |
| `#3FB864` | `AppColors.buttonsBackground` |
| `#35BEAA → #93D772` gradient | `AppColors.gradientAMYFQ6` |
| `rgba(156,211,158,0.16)` | `const Color(0x1A9CD39E)` |
| `#E2E2E2` | `AppColors.fillX1WXPG` |
| `#F1F3F2` | `AppColors.fillLD2O82` |
| `#1A1A1A` | `AppColors.color00Primary` |

### Step 5: Map Figma Spacing to Project Spacing

| Figma px | Project token |
|---|---|
| 2 | `AppSpacing.xxs` |
| 4 | `AppSpacing.xs` |
| 6 | `AppSpacing.xs6` |
| 8 | `AppSpacing.sm` |
| 10 | `AppSpacing.sm10` |
| 12 | `AppSpacing.md` |
| 16 | `AppSpacing.lg` |
| 20 | `AppSpacing.xl` |
| 24 | `AppSpacing.xxl` |
| 32 | `AppSpacing.xxxl` |

### Step 6: Map Figma Border Radius to Project Tokens

| Figma radius | Project token |
|---|---|
| 4 | `AppSpacing.radiusSm` |
| 8 | `AppSpacing.radiusMd` |
| 12 | `AppSpacing.radiusLg` |
| 16 | `AppSpacing.radiusXl` |
| 20 | `AppSpacing.radiusXXl` |
| 24 | `AppSpacing.xxl` (used as radius) |
| 100 / 9999 | `AppSpacing.radiusRound` |

### Step 7: Map Figma Typography to Project Font Styles

All font styles are in `AppFontStyle`. Pattern: `AppFontStyle.{weight}{size}(context)`.

| Figma | Project |
|---|---|
| Regular 10 | `AppFontStyle.regular10(context)` |
| Regular 12 | `AppFontStyle.regular12(context)` |
| Regular 13 | `AppFontStyle.regular13(context)` |
| Regular 14 | `AppFontStyle.regular14(context)` |
| Regular 16 | `AppFontStyle.regular16(context)` |
| SemiBold 14 | `AppFontStyle.semiBold14(context)` |
| SemiBold 16 | `AppFontStyle.semiBold16(context)` |
| SemiBold 18 | `AppFontStyle.semiBold18(context)` |
| Bold 14 | `AppFontStyle.bold14(context)` |
| Bold 16 | `AppFontStyle.bold16(context)` |
| Bold 18 | `AppFontStyle.bold18(context)` |

### Step 8: Map Figma Icons to Project Assets

Icons are SVGs in `AppImages`. Common mappings:

| Figma icon name | `AppImages` constant |
|---|---|
| filter / tune | `AppImages.filter` |
| close / X | `AppImages.close` |
| arrow-right / back | `AppImages.arrowRight` |
| location / map-pin | `AppImages.icLocationPin` |
| map | `AppImages.icMapPin` |
| book / subject | `AppImages.icBook` |
| graduation / grade | `AppImages.icGraduation` |
| online-offline | `AppImages.icOnlineOffline` |
| star (gold) | `AppImages.starGold` |
| star (outline) | `AppImages.starOutline` |
| male / gender | `AppImages.male` |
| price / IQ | `AppImages.icPrice` |
| search | `AppImages.search` |

Use `SvgPicture.asset(AppImages.xxx, colorFilter: ColorFilter.mode(color, BlendMode.srcIn))` to tint icons.

---

## Common Figma Patterns → Flutter Translations

### Card with Cover Image + Content

```dart
// Figma: rounded container, image top, content bottom
Container(
  decoration: BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(AppSpacing.radiusLg), // 12px
  ),
  clipBehavior: Clip.hardEdge,
  child: Column(
    children: [
      // Cover image with fixed height
      SizedBox(
        height: 124,
        width: double.infinity,
        child: CachedNetworkImage(imageUrl: url, fit: BoxFit.cover),
      ),
      // Content
      Padding(padding: EdgeInsets.all(AppSpacing.sm), child: ...),
    ],
  ),
)
```

### Gradient Button

```dart
// Figma: bg-gradient-to-r from-[#35beaa] to-[#93d772], radius-96px
GestureDetector(
  onTap: onTap,
  child: Container(
    height: 44,
    decoration: BoxDecoration(
      gradient: AppColors.gradientAMYFQ6,
      borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
    ),
    alignment: Alignment.center,
    child: Text(label, style: AppFontStyle.regular14(context).copyWith(color: AppColors.white)),
  ),
)
```

### Sort Option Row (selected/unselected)

```dart
// Figma: h-40, radius-100px
// Selected: rgba(156,211,158,0.16) bg + #35BEAA border + green checkmark
// Unselected: #F8FAFC bg, no border, grey circle
AnimatedContainer(
  height: 40,
  decoration: BoxDecoration(
    color: isSelected ? const Color(0x1A9CD39E) : AppColors.neutralBackground,
    borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
    border: isSelected ? Border.all(color: const Color(0xFF35BEAA)) : null,
  ),
  ...
)
```

### Dropdown Row (filter field style)

```dart
// Figma: bg-#F8FAFC, radius-16, p-12, no border
// Layout: [chevron] [selectedLabel?] [Expanded title] [icon]
Container(
  padding: const EdgeInsets.all(AppSpacing.md),
  decoration: BoxDecoration(
    color: AppColors.neutralBackground,
    borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
  ),
  child: Row(children: [chevron, selectedLabel?, Expanded(title), icon]),
)
```

### Section Card (white card container)

```dart
// Figma: bg-white, radius-24, p-12, no border
Container(
  padding: const EdgeInsets.all(AppSpacing.md),
  decoration: BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(AppSpacing.xxl),
  ),
  child: child,
)
```

### AppBar (RTL layout)

```dart
// Figma RTL: right = back/close, center = title, left = action
Row(
  children: [
    actionWidget,          // left (leading in RTL)
    Expanded(child: Text(title, textAlign: TextAlign.center)),
    backWidget,            // right (trailing in RTL)
  ],
)
```

### Filter Badge on Icon

```dart
Stack(
  clipBehavior: Clip.none,
  children: [
    iconButton,
    if (count > 0)
      Positioned(
        top: -2, left: -2,
        child: Container(
          width: 16, height: 16,
          decoration: BoxDecoration(
            gradient: AppColors.gradientAMYFQ6,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.white, width: 1.5),
          ),
          child: Text('$count', ...),
        ),
      ),
  ],
)
```

### Gradient Text

```dart
ShaderMask(
  shaderCallback: (bounds) => AppColors.gradientAMYFQ6.createShader(
    Rect.fromLTWH(0, 0, bounds.width, bounds.height),
  ),
  child: Text(text, style: style.copyWith(color: AppColors.white)),
)
```

### Bottom Action Bar (blurred)

```dart
// Figma: backdrop-blur-8, border-top-0.5, bg rgba(246,246,246,0.88)
ClipRect(
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
    child: Container(
      decoration: BoxDecoration(
        color: const Color(0xE0F6F6F6),
        border: Border(top: BorderSide(color: AppColors.neutralBorder, width: 0.5)),
      ),
      child: SafeArea(top: false, child: ...),
    ),
  ),
)
```

---

## File Organization Rules

Follow the project's clean architecture. New widgets go in:

```
lib/feature/app_version/student/{feature}/presentation/
  screen/          ← screens (one per route)
  widgets/         ← reusable widgets for this feature
  cubit/           ← cubit + events + states
```

For shared/reusable widgets across features:
```
lib/core/widgets/
```

### Widget Naming Convention

- Screen-specific, non-reusable → private class `_WidgetName` in the same file
- Feature-specific, potentially reused within feature → separate file in `widgets/`
- Cross-feature reusable → `lib/core/widgets/`

---

## Checklist Before Submitting

- [ ] `get_design_context` called with correct node ID
- [ ] `get_screenshot` called and used as visual reference
- [ ] All Figma colors mapped to `AppColors` tokens
- [ ] All Figma spacing mapped to `AppSpacing` tokens
- [ ] All Figma typography mapped to `AppFontStyle`
- [ ] Icons use `AppImages` constants (no new icon packages)
- [ ] No `setState` for business logic — use cubit
- [ ] No method widgets — use widget classes
- [ ] Separate files for reusable widgets
- [ ] `getDiagnostics` run on all new files — zero errors
- [ ] RTL layout respected (Arabic text, icon positions)

---

## Troubleshooting

### MCP server not connected
1. Ensure Figma Desktop is open with the correct file
2. Check `.kiro/settings/mcp.json` has `"disabled": false`
3. Restart Kiro to reload MCP config

### `get_design_context` returns Code Connect prompt
Call again with `forceCode: true`.

### Response truncated
Use `get_metadata` first to get node tree, then fetch child nodes individually.

### Asset URLs (localhost)
Figma MCP returns assets as `http://localhost:3845/assets/...`. Use these URLs directly in `Image.network()` or `CachedNetworkImage` during development. For production, download and add to `assets/`.

### Icon not in AppImages
Use the closest available icon or use a Material icon as fallback:
```dart
Icon(Icons.location_on_outlined, size: 16, color: AppColors.fillBE8Q2J)
```

---

**Last Updated**: May 2026
**Version**: 1.0.0
