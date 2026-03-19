param(
    [string]$SourceRoot = "$env:USERPROFILE",
    [string]$DestinationRoot = "$env:USERPROFILE\Desktop\Backup_Utilizador"
)

<#
.SYNOPSIS
  Faz backup de pastas comuns do utilizador.
#>

$Folders = @("Desktop", "Documents", "Pictures", "Downloads")
$DateStamp = Get-Date -Format "yyyyMMdd_HHmmss"
$Destination = Join-Path $DestinationRoot $DateStamp

if (-not (Test-Path $Destination)) {
    New-Item -Path $Destination -ItemType Directory -Force | Out-Null
}

foreach ($Folder in $Folders) {
    $SourcePath = Join-Path $SourceRoot $Folder
    if (Test-Path $SourcePath) {
        $TargetPath = Join-Path $Destination $Folder
        Copy-Item -Path $SourcePath -Destination $TargetPath -Recurse -Force -ErrorAction Continue
        Write-Host "Copiado: $SourcePath -> $TargetPath"
    } else {
        Write-Warning "Pasta não encontrada: $SourcePath"
    }
}

Write-Host "Backup concluído em: $Destination"
