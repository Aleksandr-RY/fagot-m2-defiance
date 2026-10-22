# 巴松M2 — 多用途反坦克导弹模组

**游戏:** Terminator: Dark Fate – Defiance（终结者：黑暗命运——反抗军） · **已测试版本:** v1.08.1173 · **状态:** 公测（beta）

[English](README.md) · [Русский](README.ru.md) · 中文

> 玩家自制模组，仅限单机使用。与 Cats Who Play / Slitherine 无关，也未经其认可。TERMINATOR 及相关商标归其权利人所有。
>
> 中文名「巴松M2」（巴松 = 低音管/大管，乐器名）；项目原代号 Fagot-M2（Фагот，现实中苏联反坦克导弹的绰号）。中文读法完全中性，无歧义、无冒犯含义。

## 模组内容

为反坦克导弹发射器（Javelin / **Fagot-M2**，「Фагот」是现实中苏联反坦克导弹的绰号）新增三种特殊弹药，外加原版火箭：

| 图标 | 模式 | 效果 |
|---|---|---|
| 🚀 | 原版火箭 | 普通反坦克火箭 |
| 🔵 | **EMP（电磁脉冲）** | 使目标瘫痪约 45 秒；阵营不变 |
| 🟡 | **Neural Breach（「策划反叛」/ Schizo）** | 被击中的目标转为友军 *自主* 单位（友军黄色阵营） |
| 🟢 | **Cyber Hack（「接管」/ Takeover）** | 被击中的目标直接改由 *玩家操控*（玩家绿色阵营） |

![EMP](assets/icons/icon_emp.png)
![Schizo](assets/icons/icon_schizo.png)
![Takeover](assets/icons/icon_takeover.png)

模组封面（`assets/cover_t800_schizo.png`）：

![Cover](assets/cover_t800_schizo.png)

## 工作原理（简述）

- **内容层：** 通过 SpreadsheetML（`.xml`）覆盖文件追加弹药行和三种效果配置；模式由 `life_time` 签名（0.8 / 0.9 / 1.0）区分，统一 30 米效果半径。
- **运行层：** 修改后的游戏 `logic.dll` 在弹体命中时执行阵营切换，并在 TRACE 版本中仅记录被接管目标的诊断字段。没有全局 AI 钩子。
- **安全闸门：** 安装脚本会校验当前 `bin\logic.dll` 的 SHA256，只有匹配已验证基线（`29EB…6044`）才安装；安装前备份、安装后复核，回滚脚本同样校验哈希。

## 兼容性

- 已在游戏版本 **1.08.1173** 上测试。新补丁可能改变 PAK 内容——使用前请重新校验包。
- 支持单人战役、遭遇战（Skirmish）以及两个 DLC（We Are Legion / Uprising）；DLC 数据在安装时由已安装的 PAK 生成。

## 安装（Windows）

1. 关闭游戏。
2. 将模组文件夹复制到 `…\Terminator Dark Fate - Defiance\Terminator Dark Fate - Defiance\mods\<模组文件夹>\`。
3. 运行 `INSTALL_FINAL.bat`。
4. 游戏内 → **MODS** 菜单 → 只启用本模组，停用旧版 FagotM2。
5. 回滚：运行 `RESTORE_REV1.9.1_STABLE.bat`。

## 常见问题

- 安装器提示哈希不匹配 → 当前 `logic.dll` 不是已验证的基线。请先恢复基线（见 `docs/RELEASE_FILES.md`）。
- 出现 `[Resource 'fagot_…' not found]` → 重新运行安装器以应用俄语本地化覆盖。

## 路线图

- [ ] 修复部分被接管单位的「残留自主行动」（Takeover）——诊断版本 `REV1.9.4 TRACE V2` 正在测试
- [ ] 遭遇战平衡性调整（冷却、可用性）
- [ ] 发布公开 ZIP 与 Nexus Mods 页面
- [ ] 可选：游戏内 UI 图标（DDS）

## 版本历史与技术说明

见 [CHANGELOG.md](CHANGELOG.md) 与 [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)。

## 许可

**CC BY-SA 4.0**（署名-相同方式共享 4.0 国际）。

- 任何人都可以分享、修改与再分发——包括放进其他模组或合集——但必须**注明 Fagot-M2 项目原作者**，且衍生作品沿用相同许可。
- 按「现状」提供，不作任何担保。仅限单机/离线使用。
- 许可全文见 LICENSE 或 <https://creativecommons.org/licenses/by-sa/4.0/legalcode>

## 致谢

- 创意、测试与逆向工程：Fagot-M2 项目作者
- 早期原型：与 LLM 助手（GPT 会话）及 GLM/OpenCode 审计会话协作完成
