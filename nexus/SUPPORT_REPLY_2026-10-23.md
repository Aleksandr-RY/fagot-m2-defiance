# ЧЕРНОВИК ОТВЕТА В ПОДДЕРЖКУ NEXUS (отправить как REPLY в том же треде / тем же адресом)
# Отправитель: аккаунт LeKks. Обязателен пункт: ссылка на страницу мода (для ревью модератором).
# Секреты: не вставлять сюда никаких секретов.

--- РУС ---
Тема (reply): Fagot-M2 quarantine — follow-up, account: LeKks

Здравствуйте!

Продолжение моего запроса о сборках «Fagot-M2 REV1.9.4»: страница мода
https://www.nexusmods.com/terminatordarkfatedefiance/mods/105

1) Я изучил авто-подсказку на странице файлов: «если мод содержит скомпилированный код —
   добавьте ссылку на исходники (GitHub) и шаги сборки». Мой репозиторий открыт:
   https://github.com/Aleksandr-RY/fagot-m2-defiance
   В нём: XML-источники баланса, скрипты установщика (.bat/.ps1), документация, история ревизий
   (CHANGELOG, AUDIT). Про военный смысл: это фан-мод для офлайновой одиночной игры
   (кампания/Skirmish/DLC), меняющий одно штатное оружие (Javelin) на 4 режима Shell.

2) Просьба подсказать по самому патчу DLL (logic.dll игры слоя runtime) — что правильнее:
   (а) дождаться вашего ревью существующих двух карантинных сборок; или
   (б) я сразу заменяю их на «CLEAN»-сборку БЕЗ единого исполняемого файла:
   ZIP 3.8MB: 5 XML-оверлеев (SpreadsheetML), predefinedSaves (кампания), DLC-адаптация,
   русская локаль, mod.json, README и ОДИН скомпилированный патч-файл
   logic_FagotM2_REV1.9.4_TRACE_V2.dll (9.1MB, сборка автора). Ни .bat, ни .ps1, ни .exe;
   вложенных архивов нет; официальные PAK не затрагиваются; изоляция ручная по README
   (проверка SHA256 через certutil, бэкап, откат).
   SHA256 сборки: cb3c2e0d446287b1c2285f494cbc8b438000775b3e2463e09092999595be1517

3) Что содержат карантинные сборки (ни одна не делает ничего агрессивного):
   - XML-оверлеи боеприпасов/экипировки/эффектов (SpreadsheetML) — это данные игры;
   - predefinedSaves/globalMap.sav — сохранённая кампания с корректными squad-шаблонами;
   - patch-файлы logic_FagotM2*.dll — патч игрового runtime (смена команды при попадании ракеты),
      добавление(Takeover) — собственная работа автора; исходник подготовлен и будет
      внесён в репозиторий;
   - .bat/.ps1 — установочные утилиты: только SHA256-проверки, генерация DLC-адаптаций и локали
     из УСТАНОВЛЕННОЙ у пользователя игры через 7-Zip, копирование файлов внутри папки игры.
     Не трогают ничего вне игры; не пишут в реестр; не работают с сетью; без самозапусков.
   Убедительно прошу рассматривать файлы как игровой мод, если понадобится — дам любые
   дополнительные разъяснения.

   3a) Полные официальные манифесты Nexus (публичные) показывают состав 20/25 файлов:
   .xml (SpreadsheetML), .sav, .txt, .json + 2 .dll + 8 установочных .bat/.ps1.
   ВАЖНО: в архивах НЕТ вложенных архивов и НЕТ запароленных файлов — эти пункты
   официальной справки к нам не применимы. Единственные исполнимые элементы — те самые
   .bat/.ps1-инсталляторы; если сработал именно их фильтр, я сразу готов заменить обе
   сборки на «CLEAN»-версию без одного исполняемого файла (см. пункт 2б).

   3b) Если возможно, уточните, пожалуйста, КАКОЙ ИМЕННО файл или тип файла вызвал
   автоматический блок — так мы ответим точечно, а не вслепую.

4) Многие антивирусные движки формально реагируют на .bat/.ps1-установщики игровых модов
   (ложные срабатывания «Trojan.BAT/PS1-Agent»). Готов заменить пакет на CLEAN-версию,
   чтобы Automated check проходил без обращения к общесистемным типам файлов.

Спасибо, жду вердикта.
LeKks

--- ENGLISH ---
Subject (reply): Fagot-M2 quarantine — follow-up, account: LeKks

Hello,

A follow-up on my earlier request about the two quarantined uploads on my mod page:
https://www.nexusmods.com/terminatordarkfatedefiance/mods/105

1) I read the on-page guidance: for compiled code, a source-code link plus build steps should
   be provided. My public repository (XML data sources, installer scripts .bat/.ps1, docs,
   full revision history) is:
   https://github.com/Aleksandr-RY/fagot-m2-defiance

2) Two options — please advise which you prefer:
   (a) wait for your review of the two currently quarantined files; or
   (b) I immediately replace them with a "CLEAN" upload that contains NO executables at all:
   a 3.8 MB ZIP with five SpreadsheetML XML overlays, a predefined campaign save, a DLC
   adaptation file, the Russian locale file, mod.json, a README, and ONE compiled
   game-runtime patch file logic_FagotM2_REV1.9.4_TRACE_V2.dll (9.1 MB, author-built).
   No .bat, no .ps1, no .exe, no nested archives, official game PAK archives are never
   modified; manual install per README with SHA256 checks via certutil and a backup/rollback.
   SHA256 of the prepared clean upload:
   cb3c2e0d446287b1c2285f494cbc8b438000775b3e2463e09092999595be1517

3) Contents of the quarantined files (nothing performs aggressive actions):
   The full official Nexus manifests (public endpoints) list 20/25 members: .xml
   (SpreadsheetML), .sav, .txt, .json, plus 2 .dll and 8 installer files (.bat/.ps1).
   IMPORTANT: the archives contain NO nested archives and NO password-protected files —
   those help-article reasons do not apply. The only executable items are the .bat/.ps1
   installers; if the filter reacted to them, I can immediately replace both uploads with
   a "CLEAN" build without a single executable (see option 2b above).

   3a) If possible, please tell us WHICH file or file type triggered the automated block —
   so we can respond precisely instead of reworking files blindly.
   - SpreadsheetML XML overlays that add ammunition/equipment/effect rows (game data);
   - basis/predefinedSaves/globalMap.sav — a predefined campaign save with corrected squad
     templates;
   - logic_FagotM2*.dll patch files — a patch of the game runtime that performs a team switch
     on projectile impact (own work of the author);
   - .bat/.ps1 installer utilities: SHA256 verification only, generating DLC/localization
     adaptations from the USER'S OWN INSTALLED game files via 7-Zip, and copying files inside
     the game folder. Nothing outside the game folder, no registry, no network, no
     self-extractors.
4) Generic AV engines often regression-flag .bat/.ps1 installers of game mods (false
   positives like "Trojan.BAT/PS1.Agent"). I am happy to ship only the CLEAN build to keep the
   automated checks clean.

Thank you for your time — awaiting your verdict.
LeKks
