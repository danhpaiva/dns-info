<#
.SYNOPSIS
    Script para configurar DNS (Cloudflare ou Google) corrigido.
#>

$ErrorActionPreference = "Stop"

# Verifica privilégios de Admin
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Por favor, execute este script como Administrador!"
    break
}

Write-Host "--- DNS Turbocharger v1.1 (Hotfix) ---" -ForegroundColor Cyan
Write-Host "1. Cloudflare (1.1.1.1)"
Write-Host "2. Google (8.8.8.8)"
Write-Host "3. Resetar para DHCP"
$choice = Read-Host "Escolha uma opção (1-3)"

# Identifica a interface ativa
$interface = Get-NetAdapter | Where-Object { $_.Status -eq "Up" } | Select-Object -First 1

if (-not $interface) {
    Write-Error "Nenhuma interface de rede ativa encontrada."
    return
}

Write-Host "Configurando interface: $($interface.Name)..." -ForegroundColor Yellow

switch ($choice) {
    "1" {
        $v4 = @("1.1.1.1", "1.0.0.1")
        $v6 = @("2606:4700:4700::1111", "2606:4700:4700::1001")
    }
    "2" {
        $v4 = @("8.8.8.8", "8.8.4.4")
        $v6 = @("2001:4860:4860::8888", "2001:4860:4860::8844")
    }
    "3" {
        Set-DnsClientServerAddress -InterfaceAlias $interface.Name -ResetServerAddresses
        Write-Host "DNS resetado com sucesso!" -ForegroundColor Green
        return
    }
    Default { Write-Host "Opção inválida."; return }
}

# Aplicando as configurações de forma simplificada
# O PowerShell detecta automaticamente se é v4 ou v6
try {
    Write-Host "Setando IPv4..." -NoNewline
    Set-DnsClientServerAddress -InterfaceAlias $interface.Name -ServerAddresses $v4
    Write-Host " [OK]" -ForegroundColor Green

    Write-Host "Setando IPv6..." -NoNewline
    Set-DnsClientServerAddress -InterfaceAlias $interface.Name -ServerAddresses $v6
    Write-Host " [OK]" -ForegroundColor Green

    Write-Host "Limpando cache do DNS..."
    ipconfig /flushdns
    Write-Host "Tudo pronto!" -ForegroundColor Cyan
}
catch {
    Write-Error "Erro ao aplicar DNS: $($_.Exception.Message)"
}
