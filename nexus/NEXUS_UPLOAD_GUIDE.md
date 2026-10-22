# Nexus Mods upload guide — Fagot-M2

Target: https://www.nexusmods.com/terminatordarkfatedefiance (game hub verified 2026-10-22)

## Page fields (mod page creation form)

| Field | Value |
|---|---|
| Title | **Fagot-M2 — Multirole ATGM Suite** |
| Uploaded by / version | `1.9.4` |
| Description | paste `nexus/NEXUS_DESCRIPTION.bbcode` (whole file content; the `#` comment lines must be removed before pasting) |
| Category | `Gameplay` (fallback: `Weapons` if a game-specific list appears — pick closest) |
| File archive | game's own `.zip` — manual install with installer scripts, so **No, file is packaged manually** for "prepared with mod manager" |
| License | Nexus license dropdown: **Creative Commons Attribution-ShareAlike** (CC BY-SA) |
| Permissions | Allow credit, no permission to convert/upload elsewhere **without credit**; uploads to other sites only with permission (per CC BY-SA attribution rule — mirrors must credit) |

## Files tab

- Main file: `FagotM2_FINAL_4MODES_REV1.9.4_TRACE_V2.zip` (6.88 MB), version `1.9.4`, category "Main files".
- Mark as Public beta. Changelog BBCode: `nexus/NEXUS_CHANGELOG.bbcode`.

## Images tab

Order (first = page preview):
1. `assets/cover_t800_schizo.png` — main cover.
2. `assets/icons/icon_emp.png`, `icon_schizo.png`, `icon_takeover.png` — mode icons (can be one combined screenshot later).
3. (optional, later) in-game screenshots from home PC: Skirmish, one Takeover shot with green vehicle under player control, one Schizo shot with yellow ally vehicle.

## Discipline

- **Standing rule — language order (author's decree, 22 Oct 2026):** EVERY publication from now on — Nexus page updates, GitLab, Yandex Disk, forum posts, release notes, README changes, mod summaries — follows the fixed order: **Русский → 中文 → English**. English always goes last. No exceptions.
- Never claim testing/verification that hasn't happened. Current honest status: **public beta**, static package audit passed 2026-10-22, behavioral TRACE test pending.
- The description includes known issues (Takeover residual AI) — keep it there until fixed.
- All three user-visible languages (RU → ZH → EN per the standing rule) live in the single description field. The intro in each language states the mod **replaces the vanilla Javelin ATGM** with the Fagot-M2.
