# SUPPORT_REPLY_2026-10-28 — follow-up for the quarantine thread (mod 105)

Paste as a reply in the moderation/support thread. Tone: cooperative, factual.

---

Hello again,

Following up on the quarantine of mod #105 (Fagot-M2). We have rebuilt the distribution completely to comply with the upload rules:

**What was wrong before:** the previous archive contained installer scripts (.bat/.ps1), which falls under the "executables/scripts" restriction.

**What we changed:**

1. **The Nexus archive is now data-only.** XML overrides, a predefined save, mod.json and a trilingual README (RU/ZH/EN). Zero .bat/.ps1/.exe, no nested archives, no game files redistributed. Installation is fully manual: copy the folder into mods\ and enable it in the in-game MODS menu.

2. **The installer scripts are published openly as source code on GitHub:**
https://github.com/Aleksandr-RY/fagot-m2-defiance (public repo, full commit history, MIT-style transparency — nothing obfuscated). They are optional and only needed for the engine-layer feature (4 fire modes); they patch the user's own game file in place after verifying its SHA256. No ready-made game binaries are distributed anywhere.

3. **Integrity manifest** for every artifact (stock / patched SHA256) is published in the repo (BUILD_INFO.json), and the README explains the hash check with certutil.

4. **Honest beta disclosure** — known issues are listed in the file description, not hidden.

The updated CLEAN archive is ready to upload (FagotM2_2.0.0_NEXUS_CLEAN.zip, ~144 KB). Could you please review and advise whether the mod can be restored / the new file uploaded, or if anything else is required from our side?

Thank you!

---

## Памятка юзеру (не для поста)
- Прикладывай к посту: ссылку на GitHub-репо + список содержимого CLEAN-зипа (README_CLEAN.txt сам это описывает).
- Не упоминай пароль PAK и внутренние SHA-таблицы окон — только «hash-gated installer, source on GitHub».
- Языки поста: EN (модераторы), потом при желании дубль RU под ним.
- Если попросят «re-upload and wait in queue» — заливаешь CLEAN-зип в Files → Main, версию 2.0.0, и снова в ожидание.
