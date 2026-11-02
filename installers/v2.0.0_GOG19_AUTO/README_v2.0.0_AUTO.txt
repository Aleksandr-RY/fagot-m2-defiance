================================================================
 Fagot-M2 v2.0.0 - GOG AUTO package (engine auto-detect)
 for: Terminator: Dark Fate - Defiance GOG, single player only
================================================================
This package works on ANY supported GOG build:
  - current 1.09.1223    (logic.dll 9,253,648 B)
  - older 1.09 Sep 2026  (logic.dll 9,212,928 B)
  - 1.08.1173            (logic.dll 9,104,384 B)
The engine installer reads your bin\logic.dll SHA256 and applies
the matching patch chain (in-place; no ready-made DLL files).

INSTALL (Windows)
------------------------------------------------
1. Close the game.
2. Copy the mod folder (this folder) into ...\mods\ of the game,
   then run INSTALL_v2.0.0_AUTO.bat:
   [1/2] XML overrides are rebuilt from YOUR game PAKs (7-Zip needed),
   [2/2] logic.dll is patched with SHA check + backup.
3. In-game: MODS menu -> enable "Fagot-M2 FINAL 4 Modes v2.0.0".

ROLLBACK
------------------------------------------------
RESTORE_GOG_AUTO.bat restores the newest logic.dll.*.bak backup.

KNOWN ISSUES
------------------------------------------------
- residual AI on captured units (they move but do not attack);
- Legion transports: passengers keep old team binding;
- campaign: use predefinedSaves after the 3rd tutorial mission;
- rare hang on exit after heavy fire-mode use (race, under test);
- the launcher icon falls back to the default one;
- diagnostics: bin\FagotM2_debug.log - attach it to bug reports.

LICENSE: CC BY-SA 4.0. Author: LeKks.
https://github.com/Aleksandr-RY/fagot-m2-defiance
================================================================