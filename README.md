# Fagot-M2 — Multirole ATGM Suite

**Game:** Terminator: Dark Fate – Defiance · **Tested on:** v1.08.1173 · **Status:** public beta

English · [Русский](README.ru.md) · [中文](README.zh.md)

> Fan-made mod for offline/single-player use. Not affiliated with, or endorsed by, Cats Who Play or Slitherine Software. TERMINATOR and related marks belong to their respective owners.
>
> **Fagot-M2** (Фагот-М2) — the name follows the real-world Soviet ATGM family «Фагот» (AT-4 series, NATO-reported "Fagot"; the word also means "bassoon" — the musical instrument). Chinese-title rendering: 法戈特M2.

## What this mod adds

This mod **replaces the vanilla Javelin ATGM with the Fagot-M2 multirole ATGM suite** («Фагот» — real-world Soviet ATGM nickname). It adds three special ammunition types, plus the stock rocket — four selectable fire modes total:

| Icon | Mode | Effect |
|---|---|---|
| 🚀 | Stock ATGM | regular anti-tank rocket |
| 🔵 | **EMP** | suspends the target for ~45 s; no team change |
| 🟡 | **Neural Breach** («Schizo») | captured target becomes an allied *autonomous* unit (ally-colored team) |
| 🟢 | **Cyber Hack** («Takeover») | captured target comes under *direct player control* (player team) |

![EMP](assets/icons/icon_emp.png)
![Schizo](assets/icons/icon_schizo.png)
![Takeover](assets/icons/icon_takeover.png)

Mod cover art (`assets/cover_t800_schizo.png`):

![Cover](assets/cover_t800_schizo.png)

## How it works (short version)

- **Content layer:** SpreadsheetML (`.xml`) overrides add the ammo rows and three effect profiles; the launcher mode is dispatched by the `life_time` signature (0.8 / 0.9 / 1.0) with a shared 30 m effect radius.
- **Runtime layer:** a patched game `logic.dll` performs the team switch at projectile impact and (in TRACE builds) logs diagnostic fields of the captured unit only. No global AI hooks.
- **Safety gates:** the installer refuses to install unless the current `bin\logic.dll` matches the verified baseline (`SHA256 29EB…6044`); it creates a verified backup first and re-verifies after copy. One-command rollback is hash-verified too.

## Compatibility

- Game build **1.08.1173** (tested). Newer patches may change PAK contents — re-run the package audit before trusting it.
- Works in the single-player campaign, Skirmish, and the DLCs (We Are Legion / Uprising); DLC rows are generated from your installed PAKs at install time.

## Installation (Windows)

1. Close the game.
2. Copy the mod folder to `…\Terminator Dark Fate - Defiance\Terminator Dark Fate - Defiance\mods\<mod folder>\`.
3. Run `INSTALL_FINAL.bat`.
4. In-game → **MODS** menu → enable this package; disable any older FagotM2 versions.
5. Rollback: run `RESTORE_REV1.9.1_STABLE.bat`.

## Troubleshooting

- Installer aborts with hash mismatch → your `logic.dll` is not the verified baseline. Restore the baseline first (see `docs/RELEASE_FILES.md`).
- Locale strings show as `[Resource 'fagot_…' not found]` → re-run the installer so the Russian locale override applies.

## Roadmap

- [ ] Fix "residual AI" on some captured units (Takeover) — diagnostic build `REV1.9.4 TRACE V2` under testing
- [ ] Balance pass (cooldowns, availability) for Skirmish
- [ ] Public release ZIP + Nexus Mods page
- [ ] Optional: in-game UI icons (DDS)

## Changelog & status

See [CHANGELOG.md](CHANGELOG.md) and [docs](docs/ARCHITECTURE.md).

## License

**CC BY-SA 4.0** (Creative Commons Attribution-ShareAlike 4.0 International).

- You may share, modify and redistribute for any purpose — including other mods and mod packs — as long as you **credit the Fagot-M2 project author** (the original mod creator) and keep derivatives under the same license.
- Provided "as is", without warranty of any kind. Single-player/offline use only.
- Full legal text: core/LICENSE or <https://creativecommons.org/licenses/by-sa/4.0/legalcode>

## Credits

- Concept, testing, and reverse-engineering sessions: the Fagot-M2 project author
- Early prototyping: work with LLM assistants (GPT sessions) and the current GLM/OpenCode audit session
