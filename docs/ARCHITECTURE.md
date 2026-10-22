# Architecture — how Fagot-M2 is built

*(Short technical map so any future session/tool can pick up the project without re-reverse-engineering. Facts only; unverified items are marked.)*

## 1. Three layers

### a) Content layer (no code)
SpreadsheetML overrides copied from `basis\scripts\species\`:

| File | Content |
|---|---|
| `ammunition.xml` | three Fagot-M2 ammo rows |
| `emp.xml` | three effect profiles — the mode dispatcher lives here |
| `guns.xml`, `squads.xml`, `squad_upgrades.xml` | launcher integration, squad-level access |
| `dlc/Resistance/.../squads.xml` | DLC squad carry-over |
| `locale/ru/.../ammunition.xml` | RU display names |

**Dispatch signature:** the game's EMP profile is reused. DLL recognizes the mode by `life_time`:

| life_time | Mode | Team effect |
|---|---|---|
| 0.8 | EMP | none (suspension only, ~45 s) |
| 0.9 | Schizo / Neural Breach | target → allied autonomous AI team |
| 1.0 | Takeover / Cyber Hack | target → player team |

Radius unified at 30 for all modes (earlier REV1.5 used radii 31/32 — abandoned).

Notes: profiles carry `hit_earth_emp:1.5` and splash falloff `30:2; 50:0.8; 100:0.8; 160:0` (see `emp.xml`).

### b) Runtime layer (logic.dll patch)
- Team switch happens in the hit-processing path of the existing REV1.9.1 logic.
- Skirmish: `oldTeam=1` (Legion) → `newTeam=0` (player); `player_ally resolved=4`.
- Campaign: `oldTeam=2` → `newTeam=13` (`player_ally`), occasionally `2 → 0`.
  ⚠️ These numbers are *observed*, team-ID semantics were not confirmed by disassembly (per handoff rule 10).
- TRACE builds add hit-scoped logging (target object only): `entityLo`, `stateLo`, `p20|p28|p48` + `…VTLo` vtable low-words. No global AI hooks (REV1.9.4 v1 showed why: `trm.exe` crash + infantry AI degradation).

### c) Safety layer (tooling)
- INSTALL: refuses anything except verified REV1.9.1 base; makes hash-verified backup; verifies install.
- RESTORE to REV1.9.1: hash-verified from the package-embedded DLL (fixes the historical restore-returning-wrong-version bug).
- CLEAR/COLLECT log scripts; every test session: clear → game → close → collect.

## 2. The current open problem (Takeover)

Some captured units (spiders/robots/terminators) accept player orders **and** keep acting autonomously. Working hypothesis (unverified): different unit classes use different AI/controller states, and the current patch only changes team/group, leaving the native controller alive.

Plan: run TRACE V2, take one obedient + one disobedient capture in Skirmish, compare `stateVTLo / p28VTLo` between the two classes; a differing vtable would confirm the "different controller" hypothesis → minimal targeted patch later. Do **not** re-try `DUMMY/NONE`, blocked `move/attack`, or global hooks (documented regressions).

## 3. Reference mission data

`3rd_mission.swt` (Abiquiu) contains script actions resembling what we need: `a_changeUnitBehaviorAndAiType`, `a_stop`, `a_changeTeamForUnits`, `a_setGroupName`. Not yet proven applicable to captured Legion units — reference only.
