# Nexus Mods upload guide — Fagot-M2 (v2.0.0 CLEAN edition)

Target: https://www.nexusmods.com/terminatordarkfatedefiance (game hub verified 2026-10-22)
Current status: mod #105 in **quarantine since 2026-10-23** — before anything, post
`nexus/SUPPORT_REPLY_2026-10-28.md` in the support thread and wait for moderator action.

## Page fields (mod page creation/update form)

| Field | Value |
|---|---|
| Title | **Fagot-M2 — Multirole ATGM Suite** |
| Version | `2.0.0` |
| Description | paste `nexus/NEXUS_DESCRIPTION.bbcode` (whole file content; the `#` comment lines must be removed before pasting) |
| Category | `Gameplay` (fallback: `Weapons` if a game-specific list appears — pick closest) |
| File archive | `FagotM2_2.0.0_NEXUS_CLEAN.zip` (~144 KB) — manual install, so **No, file is packaged manually** for "prepared with mod manager" |
| License | Nexus license dropdown: **Creative Commons Attribution-ShareAlike** (CC BY-SA) |
| Permissions | Allow credit; conversions/uploads elsewhere only with credit (CC BY-SA) |

## Files tab

- Main file: `FagotM2_2.0.0_NEXUS_CLEAN.zip`, version `2.0.0`, category "Main files".
- Mark as **Public beta**. Known issues are listed in the description — do not hide them.
- Changelog box: paste `nexus/NEXUS_CHANGELOG.bbcode`.
- The archive contains NO scripts/exes (Nexus rules): XML + predefinedSaves + mod.json + README_CLEAN only.

## The engine layer stays on GitHub

The 4-mode mechanics = in-place byte patch of the user's own logic.dll.
Installers live ONLY in the GitHub repo (`installers/`) and are linked from the description.
Never upload them to Nexus (quarantine reason).

## Languages

Description order: RU → ZH → EN in one field (already structured that way in the bbcode file).
