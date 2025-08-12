# Скрипт для анализа групп принтеров в Active Directory

Этот PowerShell-скрипт предназначен для автоматического поиска групп Active Directory, связанных с принтерами (по шаблону `printer*` и `printerSPB*`), и формирования отчёта о пользователях, имеющих к ним доступ — включая тех, кто входит в группы через вложенные членства.

---

## 🎯 Назначение

В организациях доступ к принтерам часто управляется через группы безопасности в Active Directory. Этот скрипт:

- Находит все группы, соответствующие шаблонам:
  - `printer123`
  - `printerSPB456`
- Рекурсивно раскрывает вложенные группы.
- Собирает список всех пользователей, имеющих доступ к принтерам.
- Формирует отчёт в формате CSV для анализа или аудита.

---

## 📦 Требования

- Windows с установленным модулем **Active Directory PowerShell (RSAT)**.
- Права на чтение объектов в Active Directory (рекомендуется запуск от имени учётной записи с правами администратора домена или члена группы `Domain Admins`).
- PowerShell 5.1 или выше.

> Установка RSAT (на Windows 10/11/2016+):
> ```powershell
> Add-WindowsCapability -Name OpenSSH.Client~~~~0.0.1.0 -Online
> # Для RSAT:
> Get-WindowsCapability -Name "Rsat.ActiveDirectory.DS-LDS.Tools*" -Online | Add-WindowsCapability -Online
> ```

---

## 🚀 Как использовать

1. Сохрани скрипт как `Get-PrinterAccessReport.ps1`.
2. Запусти PowerShell **от имени администратора**.
3. Выполни:

```powershell
.\Get-PrinterAccessReport.ps1
