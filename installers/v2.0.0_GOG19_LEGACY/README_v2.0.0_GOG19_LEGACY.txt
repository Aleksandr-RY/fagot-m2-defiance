================================================================
 Fagot-M2 v2.0.0 (engine REV1.9.2L) - LEGACY GOG build package
 for: Terminator: Dark Fate - Defiance GOG, OLD 1.09 build
 (bin\logic.dll = 9,212,928 bytes, PE timestamp 14.09.2026)
================================================================

WHICH PACKAGE DO I NEED?
  - If your bin\logic.dll is 9,253,648 B (current 1.09.1223):
    use the MAIN package (FagotM2_v2.0.0_GOG19.zip) instead!
  - This LEGACY package is ONLY for the older GOG 1.09 build
    (logic.dll 9,212,928 B). The installer refuses any other
    build and changes nothing when the SHA does not match.

INSTALL (Windows, single player / offline only)
------------------------------------------------
1. Close the game.
2. Replace the files in this mod folder (mods\FagotM2_2.0.0_1.0.9_GOG)
   with these, then run INSTALL_v2.0.0_GOG19_LEGACY.bat.
   It will:
   [1/2] rebuild the XML overrides from YOUR game PAKs (needs 7-Zip),
   [2/2] byte-patch your bin\logic.dll in place:
         stock 30264904... -> master c6e59f19... (REV1.9.2L),
         with SHA check, backup and one-command rollback.
3. In the game: MODS menu -> enable "Fagot-M2 FINAL 4 Modes v2.0.0".

ROLLBACK
------------------------------------------------
Run RESTORE_GOG19_LEGACY.bat - restores bin\logic.dll from
logic.dll.GOG19legacy_stock.bak. The XML overrides live inside
the mod folder and are removed together with the folder.

WHAT IS PATCHED (engine REV1.9.2L)
------------------------------------------------
Same engine as the main GOG19 build (REV1.9.2), transferred to
the legacy compile:
  - new PE section .fgt5 (VA 0x8D8000, raw 0x8C9400, +4096 B),
  - 4 hook trampolines -> team-switch on projectile impact,
  - REV1.9.2 vtable range-guard vs the Schizo/Takeover crash,
  - CRT imports (fflush/fwrite/fopen_s/fclose) re-bound by the
    import table of YOUR build,
  - return-to-text re-anchored to this compile (0x34A570),
  - loader check: LoadLibraryEx accepted before shipping.

KNOWN ISSUES (same as main page)
------------------------------------------------
- residual AI on captured units (moves, does not attack);
- Legion transports: passengers keep old team binding;
- campaign: use predefinedSaves after the 3rd tutorial,
  mission "destroy" targets must actually die;
- rare hang on exit after heavy fire-mode use (race);
- the launcher icon falls back to the default one;
- diagnostics log: bin\FagotM2_debug.log - attach it to bug reports.

LICENSE: CC BY-SA 4.0. Author: LeKks.
Project page: https://github.com/Aleksandr-RY/fagot-m2-defiance
================================================================
