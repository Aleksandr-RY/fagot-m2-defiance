# Changelog — Fagot-M2 (Terminator: Dark Fate – Defiance)

Facts in this file come from the project technical handoff (`FagotM2_Technical_Handoff.md`) and the 2026-10-22 package audit. Internal builds were never published.

## REV1.5 — collision fix (internal, 2026-08)

- EMP / Schizo / Takeover dispatch split by blast radius: 30 / 31 / 32 (DLL: 31 → player_ally, 32 → player).
- CLI/DLL build `logic_FagotM2_FINAL_MULTIROLE.dll` (`d4526bc9…`).

## REV1.7 — Win64 ABI/trampoline fix (internal)

- Windows x64 ABI/trampoline corrections; REV1.7 DLL retained as a safe legacy Fagot-M2 build.

## REV1.8 — same-radius profile signature (internal, 2026-08-30)

- Unified effect radius = 30 for all modes; mode dispatch moved to `life_time` signature: EMP `0.8`, Schizo `0.9`, Takeover `1.0`; suspension bias `suspension_duration = 45`.
- `emp.xml` replaced (`152ae0bf…`); PREPARE script regenerates DLC rows (We Are Legion / Uprising) and Russian locale.
- Installer updated to expect the REV1.8 DLL SHA256 (`9dabf1db…`).

## REV1.9 TEST (internal)

- Added group switch to `player` after the team switch; heavier vehicles behave better, but some robots/spiders still act autonomously under player+AI mixed control.

## REV1.9.1 — last verified stable base (internal)

- `logic.dll` SHA256: `29EB0525E947321A5A4BC2A5CE52A4DAB4792B28E48717CA25B4827348346044` — reference baseline. Takeover still imperfect, but this is the checkpoint all experiments must branch from.

## REV1.9.2 — AI-BLOCK (abandoned, never a base)

- Blocked `move/attack` commands — does not match the observed problem (units walk on the map). Do not develop without new evidence.

## REV1.9.3 — AI-DUMMY (regression, do not use)

- `DUMMY/NONE` behavior changes froze some player-side vehicles in an infinite EMP state. Not a base.

## REV1.9.4 TRACE v1 (crashed, do not use)

- Global interception of `CHANGE_BEHAVIOR_AI`; Schizo shot crashed `trm.exe`; Legion infantry AI degraded. Not a base.

## REV1.9.4 TRACE V2 (current, awaiting in-game test)

- Diagnostic build over verified REV1.9.1 (`base 29eb0525…`, trace `f65934ce…`).
- Logs the captured Takeover target only: `entityLo/entityVTLo`, `stateLo/stateVTLo`, `p20|p28|p48 (Lo/VT)` — low 32 bits of object/controller pointers and vtables, to compare an obedient vs an autonomous captured unit.
- No gameplay changes: `global_ai_hooks=false`, EMP/Schizo/Takeover logic unchanged.
- Package audited 2026-10-22 (`AUDIT_TRACE_V2_2026-10-22.md`): hashes match, installer is hash-gated, XML overrides parse, profiles match the REV1.8 spec.
