# ОТВЕТ В PODDERJKU NEXUS — v2 (после сверки с ФАКТУАЛЬНЫМ текстом первого письма)
# Отправить как REPLY в ТОМ ЖЕ треде. Отправитель: аккаунт LeKks. В письме НЕТ секретных значений.

--- РУС ---
Тема (reply): Fagot-M2 quarantine — clarification & precise follow-up (account: LeKks)

Здравствуйте!

По моей ранней заявке по странице https://www.nexusmods.com/terminatordarkfatedefiance/mods/105

1) УТОЧНЕНИЕ ПОДГОТОВКИ. В первом письме я wrote, что архив содержит
   «an optional password-protected PAK build». Проверив фактически загруженный ZIP
   (SHA-256 1196b15cf841f5f2fc615a4653ebddcbac15c076930cbfb0c3bee2a9018e08c1)
   подтверждаю: ЭТОТ ZIP НЕ содержит ни .pak-файла, ни вложенных архивов .zip/.7z/.rar,
   ни запароленных файлов. Полный список файлов приведён в официальном манифесте Nexus
   (25 элементов: XML-оверлеи, predefinedSaves/globalMap.sav, DLC-переопределение,
   русская локаль, 2 DLL, 8 локальных .bat/.ps1 участника, mod.json, README-файлы).
   Формулировка «optional password-protected PAK build» была НЕТочной: таких отдельной
   загрузки или вложенного объекта у нас НЕТ. На странице мода отдельного PAK-файла
   тоже нет. Прошу принять это уточнение как основную версию фактов.
   Мы НЕ распространяем ни паролей, ни запароленных архивов.

2) ЧТО ДЕЛАЮТ helper-скрипты (это единственные исполняемые элементы ZIP):
   - .bat/.ps1 проверяют SHA256 файлов (в т. ч. текущего bin\logic.dll),
     делают backup и копируют наш patch-DLL на место логического runtime;
   - один из скриптов читает при помощи 7-Zip уже установленные у ПОЛЬЗОВАТЕЛЯ игровые
     PAK-архивы (basis.pak / patch_*.pak), чтобы СФОРМИРОВАТЬ локальные XML-адаптации
     DLC и русской локали — официальные PAK никогда не изменяются и не расходятся;
   - ни сети, ни реестра, ни самораспаковок, ни файлов вне папки игры.
   Понимаю, что слово «пароль» в контексте работы с архивами может выглядеть
   подозрительно: этот параметр относится ТОЛЬКО к чтению локальных игровых байтов
   пользователя (стандартный доступ к архивам самой игры), а не к какому-либо
   зашифрованному содержимому нашего пакета — его внутри просто нет.

3) VirusTotal для ZIP: 0/68 обнаружений (только метка contains-pe — внутри есть
   PE-файлы: наши 2 DLL). Отчёт: https://www.virustotal.com/gui/file/1196b15cf841f5f2fc615a4653ebddcbac15c076930cbfb0c3bee2a9018e08c1

4) Одно полезное дополнение: „logic_FagotM2_REV1.9.1_STABLE_REFERENCE.dll"
   — это НЕТ изменённая копия штатной logic.dll данной версии игры (SHA-256
   29eb0525e947321a5a4bc2a5ce52a4dab4792b28e48717ca25b4827348346044), нужен только
   для локального отката. Если политика не допускает присутствия копии системного
   файла игры — я готов её исключить (в готовом «CLEAN»-замене уже исключена):
   откат пользователю заменой собственного backup по README. Выйдет минимум
   9,1 MB из пакета.

5) Готов по запросу заменить главные файлы на «CLEAN»-сборку:
   3.8 MB ZIP, ноль исполняемых файлов/скриптов: 5 XML-оверлеев (SpreadsheetML),
   predefinedSaves (кампания), DLC-адаптация, русская локализация, один
   скомпилированный патч-файл logic_FagotM2_REV1.9.4_TRACE_V2.dll (SHA-256
   f65934cebb5c20da1d083bed3910194a067d8863d7d995237104fe4d92efafb9), mod.json и
   README с ручной установкой (certutil SHA256 контроль + backup/rollback).
   SHA-256 CLEAN-архива: cb3c2e0d446287b1c2285f494cbc8b438000775b3e2463e09092999595be1517

6) ПРОСЬБА: если возможно, укажите, какой ИМЕННО файл или тип файла вызвал
   автоматическую блок. Так исправим точечно и не прибегаем к наугад-изменениям.

7) Исходники/сборка: методы сборки патча и проверяемые шаги документируются в
   моём публичном репозитории (github.com/Aleksandr-RY/fagot-m2-defiance, BUILD_DLL.md);
   при запросе предоставлю любые нужные авторские материалы.

Если нужна дополнительная информация — скажите. Жду вашего решения. Спасибо!
LeKks (автор мода 105)

--- ENGLISH ---
Subject (reply): Fagot-M2 quarantine — clarification & precise follow-up (account: LeKks)

Hello,

Regarding my earlier request on https://www.nexusmods.com/terminatordarkfatedefiance/mods/105

1) CORRECTION. In my first email I wrote that the archive contains "an optional
   password-protected PAK build". Having verified the actually uploaded ZIP
   (SHA-256 1196b15cf841f5f2fc615a4653ebddcbac15c076930cbfb0c3bee2a9018e08c1),
   I confirm THIS ZIP contains NO .pak file, NO nested .zip/.7z/.rar archives and
   NO password-protected files. The full 25-item list is visible in the official
   Nexus manifest (XML overlays, a predefinedSaves campaign file, a DLC override,
   the Russian locale, 2 DLLs, 8 local .bat/.ps1 helpers, mod.json, READMEs).
   The "optional password-protected PAK build" wording was inaccurate: no such
   separate download or nested object exists, and there is no separate PAK file on
   the mod page. We DO NOT distribute passwords or password-protected archives.

2) What the helper scripts do (the only executable members of the ZIP):
   - .bat/.ps1 verify SHA256 digests (including the user's current bin\logic.dll),
     create a backup and copy our patch-DLL into place;
   - one script uses 7-Zip to READ the game files ALREADY INSTALLED on the user's
     machine (the game's own basis.pak / patch_*.pak) in order to generate local
     XML adaptations for DLC and Russian localization — official game archives are
     never modified or redistributed;
   - no network, no registry, no self-extractors, nothing outside the game folder.
   I understand a "password" mention can look suspicious: that parameter only serves
   reading the user's OWN locally installed game archives (standard access to the
   game's own asset format); there is nothing encrypted inside our package at all.

3) VirusTotal for the ZIP: 0/68 detections (only the "contains-pe" tag, i.e. PE
   files present — our two DLLs). Report:
   https://www.virustotal.com/gui/file/1196b15cf841f5f2fc615a4653ebddcbac15c076930cbfb0c3bee2a9018e08c1

4) One honest note: "logic_FagotM2_REV1.9.1_STABLE_REFERENCE.dll" is an UNMODIFIED
   copy of the game's stock logic.dll of this game version (SHA-256
   29eb0525e947321a5a4bc2a5ce52a4dab4792b28e48717ca25b4827348346044) shipped only
   for local rollback convenience. If policy disallows distributing a copy of the
   game's own runtime file, I can exclude it — my prepared replacement already does
   (rollback is performed by the user keeping their own backup per README). That
   also removes 9.1 MB from the package.

5) I am ready to replace the main files with a "CLEAN" build: a 3.8 MB ZIP with
   NO executables/scripts at all — five SpreadsheetML XML overlays, the predefined
   campaign save, the DLC adaptation, the Russian locale, ONE compiled runtime
   patch logic_FagotM2_REV1.9.4_TRACE_V2.dll (SHA-256
   f65934cebb5c20da1d083bed3910194a067d8863d7d995237104fe4d92efafb9), mod.json and
   a README with manual install steps (certutil SHA256 verification + backup/
   rollback). SHA-256 of the prepared CLEAN zip:
   cb3c2e0d446287b1c2285f494cbc8b438000775b3e2463e09092999595be1517

6) REQUEST: if possible, please tell me WHICH file or file type triggered the
   automated block, so I can address it precisely instead of guessing.

7) Sources/build: the patch methodology and verifiable build steps are being
   documented in my public repository (github.com/Aleksandr-RY/fagot-m2-defiance,
   BUILD_DLL.md); on request I can provide any additional authoring materials.

Thank you for your time — awaiting your verdict.
LeKks (author of mod 105)
