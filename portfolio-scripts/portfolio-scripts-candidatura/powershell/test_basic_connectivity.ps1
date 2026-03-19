param(
    [string]$Target = "8.8.8.8",
    [string]$DnsName = "www.uc.pt"
)

<#
.SYNOPSIS
  Testes básicos de conectividade e resolução DNS.
#>

Write-Host "=== TESTE DE CONECTIVIDADE ==="
Write-Host "Data: $(Get-Date)"
Write-Host ""

Write-Host "[1] Gateway predefinido"
$Gateway = (Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway -ne $null }).IPv4DefaultGateway.NextHop | Select-Object -First 1
if ($Gateway) {
    Write-Host "Gateway: $Gateway"
    Test-Connection -ComputerName $Gateway -Count 2 -ErrorAction SilentlyContinue
} else {
    Write-Warning "Gateway não encontrado."
}

Write-Host ""
Write-Host "[2] Ligação IP"
Test-Connection -ComputerName $Target -Count 2 -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "[3] Resolução DNS"
try {
    Resolve-DnsName -Name $DnsName -ErrorAction Stop | Select-Object Name, Type, IPAddress
} catch {
    Write-Warning "Falha na resolução DNS para $DnsName"
}
