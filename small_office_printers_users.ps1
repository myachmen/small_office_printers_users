# Подключаем модуль ActiveDirectory
Import-Module ActiveDirectory

# Функция для рекурсивного получения всех пользователей из группы (включая вложенные группы)
function Get-ADGroupMembersRecursive {
    param(
        [string]$GroupName
    )
    $members = @()
    try {
        $groupMembers = Get-ADGroupMember -Identity $GroupName -Recursive | Where-Object { $_.objectClass -eq 'user' }
        foreach ($member in $groupMembers) {
            $user = Get-ADUser -Identity $member -Properties DisplayName, EmailAddress, Department, Title
            $members += [PSCustomObject]@{
                PrinterGroup = $GroupName
                UserName     = $user.SamAccountName
                FullName     = $user.DisplayName
                Email        = $user.EmailAddress
                Department   = $user.Department
                Title        = $user.Title
            }
        }
    }
    catch {
        Write-Warning "Ошибка при обработке группы $GroupName : $($_.Exception.Message)"
    }
    return $members
}

# Получаем все группы, соответствующие шаблонам printer* и printerSPB*, где * — число
$allGroups = Get-ADGroup -Filter * | Where-Object {
    ($_.Name -match '^printer\d+$' -or $_.Name -match '^printerSPB\d+$')
}

# Собираем пользователей
$report = @()

foreach ($group in $allGroups) {
    Write-Host "Обработка группы: $($group.Name)"
    $users = Get-ADGroupMembersRecursive -GroupName $group.Name
    $report += $users
}

# Вывод в консоль
$report | Format-Table -AutoSize

# Сохранение отчёта в CSV
$report | Export-Csv -Path "PrinterGroupReport_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv" -Encoding UTF8 -NoTypeInformation

Write-Host "Отчёт сохранён: PrinterGroupReport_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"