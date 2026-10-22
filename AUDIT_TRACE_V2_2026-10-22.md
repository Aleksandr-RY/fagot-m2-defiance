# Аудит сборки FagotM2_FINAL_4MODES_REV1.9.4_TRACE_V2 — 22.10.2026

**Аудитор:** новый сеанс (GoldenEye/GLM), по технической передаче `FagotM2_Technical_Handoff.md`.
**Источник:** `C:\Users\ryazancev_as\Downloads\FagotM2_FINAL_4MODES_REV1.9.4_TRACE_V2.zip` (7 217 112 байт).
**Игры на этой машине НЕТ** (путь `D:\Games\...` не найден) → проведён статический аудит, ничего не устанавливалось и не менялось. Рабочая копия распакована в `C:\Users\ryazancev_as\AppData\Local\Temp\opencode\FagotM2_audit\`.

## Подтверждённые факты

### 1. Хэши DLL — сходятся с эталоном
| Файл | Фактический SHA256 | Статус |
|---|---|---|
| `logic_FagotM2_REV1.9.1_STABLE_REFERENCE.dll` | `29EB0525E947321A5A4BC2A5CE52A4DAB4792B28E48717CA25B4827348346044` | ✅ совпадает с эталонной базой REV1.9.1 из хэндоффа |
| `logic_FagotM2_REV1.9.4_TRACE_V2.dll` | `F65934CEBB5C20DA1D083BED3910194A067D8863D7D995237104FE4D92EFAFB9` | ✅ совпадает с заявленным в `BUILD_INFO_REV1.9.4_TRACE_V2.json` |

### 2. Инсталлятор и откат соответствуют правилам проекта
- `INSTALL_LOGIC_REV1.9.4_TRACE_V2.ps1`: **ставится только поверх REV1.9.1** (`29EB...`), иначе отказ с `exit 2` и без изменений; сам сверяет хэши обеих включённых DLL; перед установкой делается бэкап `logic.dll.REV1.9.1_STABLE_before_REV1.9.4_TRACE_V2` с проверкой хэша; после установки хэш перепроверяется. Правила 1–3 хэндоффа соблюдены фактически.
- `RESTORE_REV1.9.1_STABLE.ps1` / `.bat`: восстановление из DLL, вложенной в пакет, с проверкой хэша. Это закрыло старый баг «restore вернул REV1.9 вместо REV1.9.1» — больше не зависит от старых имён бэкапов в `bin`.
- `CLEAR_TRACE_LOG.bat` / `COLLECT_TRACE_LOG.bat`: очищают/копируют `bin\FagotM2_debug.log` в `FagotM2_REV1.9.4_TRACE_V2_RESULT.log` внутри папки мода. Путь игры вычисляется как `%~dp0..\..` → корректно при установке в `mods\<папку мода>`.

### 3. Состав пакета и XML
- Все 7 XML (`ammunition`, `emp`, `guns`, `squad_upgrades`, `squads`, DLC Resistance `squads`, ru-locale `ammunition`) — well-formed SpreadsheetML, парсятся без ошибок.
- Строки с `fagot` присутствуют: ammunition(9), emp(3), guns(2), squads(3), squad_upgrades(2), DLC Resistance squads(4), ru-locale ammunition(3).
- `basis\predefinedSaves\globalMap.sav` содержит `fagot` ×6 — снаряды заведены в кампанию.
- **Профили в `emp.xml` подтверждены значениями** (диспетчеризация DLL по `life_time`, радиус единый):
  - `fagot_m2_emp_profile` — life_time=`0.8`, radius=`30`, suspension=`45`
  - `fagot_m2_schizo_profile` — life_time=`0.9`, radius=`30`, suspension=`45`
  - `fagot_m2_takeover_profile` — life_time=`1`, radius=`30`, suspension=`45`
  Совпадает с `REV1.8_SAME_RADIUS_PROFILE_FIX.txt`.

### 4. Скоуп V2 — чисто диагностический
По `BUILD_INFO` и `mod.json`: логирование **только** захваченной Takeover цели, `global_ai_hooks=false`, EMP/Schizo/Takeover поведение не меняется. Трейсит поля: `entityLo/entityVTLo`, `stateLo/stateVTLo`, `p20Lo/p20VTLo`, `p28Lo/p28VTLo`, `p48Lo/p48VTLo` — низкие 32 бита указателей объекта/контроллера и их vtable. Это именно то, на чём был основан план Этапа B: сравнение vtable послушного и непослушного юнита.

## Гипотезы и неразрешённые вопросы (правило 10 — отдельно от фактов)
- Смысл team-номеров (`0` = игрок/зелёный, игрок_ally `4` в скримиш и `13` в кампании) взят из логов хэндоффа; значения наблюдались, но «кто есть кто» не подтверждён кодом.
- На этой машине **не проверить**: поведение V2 DLL в игре; точный diff XML-оверрайдов против оригинального `basis`; реальное поведение `PREPARE_DLC_AND_RU_NAMES.ps1` по DLC Legion (в ZIP лежит только Resistance `squads.xml`; остальные DLC-строки скрипт должен сгенерировать при установке из местной пакованной базы).
- `README_RU.txt` — устаревший документ REV1.8 (хэши `9dabf1...`/`152ae0...` относится к прошлой сборке). Вести учёт по `BUILD_INFO_REV1.9.4_TRACE_V2.json`.

## Следующий шаг — тест V2 (домашняя машина, путь по хэндоффу)
1. Распаковать ZIP в `D:\Games\Terminator Dark Fate - Defiance v 1.08.1173\Terminator Dark Fate - Defiance\mods\FagotM2_FINAL_4MODES_REV1.9.4_TRACE_V2\`.
2. Закрыть игру. Текущий `bin\logic.dll` должен быть REV1.9.1 (`29EB...`) — инсталлер сам проверит и откажется, если нет.
3. Запустить `INSTALL_FINAL.bat` из папки мода → ожидается `[DONE]`.
4. В меню MODS: отключить старые FagotM2-версии, включить только TRACE V2.
5. Запустить `CLEAR_TRACE_LOG.bat`.
6. Skirmish: **2–3 выстрела Takeover** — один «послушный» объект (техника/платформа) и один «непослушный» (паук/робот/терминатор). Не спамить по десяткам целей.
7. Полностью закрыть игру.
8. Запустить `COLLECT_TRACE_LOG.bat` → в папке мода появится `FagotM2_REV1.9.4_TRACE_V2_RESULT.log`.
9. Лог прислать сюда (положить в `Downloads` или в `Documents\Проект по умолчанию\terminator-mod\`).

После получения лога: сравнить `stateVTLo`/`p28VTLo` послушного vs непослушного — совпадение/различие vtable решит, у непослушных юнитов другой контроллер (гипотеза) или что-то иное. EMP и Schizo не трогать до установления причины Takeover (Этап C).
