# Release files checklist

The repository does not yet contain binaries. The following artifacts live on the **game machine** (`D:\Games\Terminator Dark Fate - Defiance v 1.08.1173\Terminator Dark Fate - Defiance\`) and must be copied here (or attached to a GitHub release) before publishing.

## Must bring from home PC

| Item | Path on game machine | SHA256 reference |
|---|---|---|
| Baseline DLL REV1.9.1 | `bin\logic.dll.REV1.9.1_before_REV1.9.3_TEST` | `29EB0525E947321A5A4BC2A5CE52A4DAB4792B28E48717CA25B4827348346044` |
| Original (pristine) DLL backup | `bin\logic.dll.FagotM2_backup` | `d320f848508c45c9f04df235204b5fbc9ffbb1b7f869e4c5a58d80bb2ecc10ed` |
| TRACE V2 installed DLL (after its in-game test) | `bin\logic.dll` | expected `F65934CEBB5C20DA1D083BED3910194A067D8863D7D995237104FE4D92EFAFB9` |
| TRACE V2 test log | `bin\FagotM2_debug.log` → copy as `FagotM2_REV1.9.4_TRACE_V2_RESULT.log` | fresh, single-session |
| Optional: original XML set for diff | extracted `basis\scripts\species\*.xml` from `basis.pak` | n/a |

## Repo layout (planned)

```
releases/            final .zip packages (hash-verified, INSTALL + RESTORE inside)
docs/full/           original XML diff packs (optional)
logs/                TRACE RESULT logs per session
```

## Publishing order

1. Confirm TRACE V2 test results (obedient vs disobedient comparisons from `RESULT.log`).
2. Decide whether Takeover fix ships first or release REV1.9.1-stable as v1.0.
3. Build final ZIP with: DLL + XML overrides + INSTALL/RESTORE/CLEAR/COLLECT scripts + READMEs.
4. Verify SHA256 of every file in the final ZIP; record in `BUILD_INFO.json`.
5. Upload to GitHub release; then export the Nexus page (description + same ZIP + screenshots).
