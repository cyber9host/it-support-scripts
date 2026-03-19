<#
.SYNOPSIS
  Recolhe informação básica do sistema Windows e guarda um relatório em texto.

.DESCRIPTION
  Útil para inventário rápido de equipamentos em contexto de suporte técnico.
#>

$OutputDir = Join-Path -Path $PSScriptRoot -ChildPath "..\output"
if (-not (Test-Path $OutputDir)) {
    New-Item -Path $OutputDir -ItemType Directory | Out-Null
}

$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$OutputFile = Join-Path $OutputDir "windows_inventory_$Timestamp.txt"

$ComputerSystem = Get-CimInstance Win32_ComputerSystem
$OperatingSystem = Get-CimInstance Win32_OperatingSystem
$BIOS = Get-CimInstance Win32_BIOS
$Processor = Get-CimInstance Win32_Processor
$Disks = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"
$NICs = Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true }

"=== INVENTÁRIO WINDOWS ===" | Out-File -FilePath $OutputFile -Encoding UTF8
"Data: $(Get-Date)" | Out-File -FilePath $OutputFile -Append -Encoding UTF8
"Nome do equipamento: $($ComputerSystem.Name)" | Out-File -FilePath $OutputFile -Append -Encoding UTF8
"Fabricante: $($ComputerSystem.Manufacturer)" | Out-File -FilePath $OutputFile -Append -Encoding UTF8
"Modelo: $($ComputerSystem.Model)" | Out-File -FilePath $OutputFile -Append -Encoding UTF8
"Utilizador atual: $env:USERNAME" | Out-File -FilePath $OutputFile -Append -Encoding UTF8
"Sistema operativo: $($OperatingSystem.Caption)" | Out-File -FilePath $OutputFile -Append -Encoding UTF8
"Versão: $($OperatingSystem.Version)" | Out-File -FilePath $OutputFile -Append -Encoding UTF8
"BIOS: $($BIOS.SMBIOSBIOSVersion)" | Out-File -FilePath $OutputFile -Append -Encoding UTF8
"CPU: $($Processor.Name)" | Out-File -FilePath $OutputFile -Append -Encoding UTF8
"RAM total (GB): {0:N2}" -f ($ComputerSystem.TotalPhysicalMemory / 1GB) | Out-File -FilePath $OutputFile -Append -Encoding UTF8

"`n=== DISCOS ===" | Out-File -FilePath $OutputFile -Append -Encoding UTF8
foreach ($Disk in $Disks) {
    "Unidade: $($Disk.DeviceID) | Tamanho (GB): {0:N2} | Livre (GB): {1:N2}" -f ($Disk.Size / 1GB), ($Disk.FreeSpace / 1GB) |
        Out-File -FilePath $OutputFile -Append -Encoding UTF8
}

"`n=== REDE ===" | Out-File -FilePath $OutputFile -Append -Encoding UTF8
foreach ($NIC in $NICs) {
    "Descrição: $($NIC.Description)" | Out-File -FilePath $OutputFile -Append -Encoding UTF8
    "IP: $($NIC.IPAddress -join ', ')" | Out-File -FilePath $OutputFile -Append -Encoding UTF8
    "Gateway: $($NIC.DefaultIPGateway -join ', ')" | Out-File -FilePath $OutputFile -Append -Encoding UTF8
    "DNS: $($NIC.DNSServerSearchOrder -join ', ')" | Out-File -FilePath $OutputFile -Append -Encoding UTF8
    "" | Out-File -FilePath $OutputFile -Append -Encoding UTF8
}

Write-Host "Relatório criado em: $OutputFile"
