<#
.SYNOPSIS
    Script para configurar DNS (Cloudflare ou Google) automaticamente.
    Executar como Administrador.
#>

$ErrorActionPreference = "Stop"

# Verifica se está rodando como Admin
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Por favor, execute este script como Administrador!"
    break
}

Write-Host "--- DNS Turbocharger v1.0 ---" -ForegroundColor Cyan
Write-Host "1. Cloudflare (1.1.1.1)"
Write-Host "2. Google (8.8.8.8)"
Write-Host "3. Resetar para DHCP (Padrão)"
$choice = Read-Host "Escolha uma opção (1-3)"

# Busca a interface de rede que está conectada à internet
$interface = Get-NetAdapter | Where-Object { $_.Status -eq "Up" } | Select-Object -First 1

if (-not $interface) {
    Write-Error "Nenhuma interface de rede ativa encontrada."
    return
}

Write-Host "Configurando interface: $($interface.Name)..." -ForegroundColor Yellow

switch ($choice) {
    "1" {
        $v4 = "1.1.1.1", "1.0.0.1"
        $v6 = "2606:4700:4700::1111", "2606:4700:4700::1001"
    }
    "2" {
        $v4 = "8.8.8.8", "8.8.4.4"
        $v6 = "2001:4860:4860::8888", "2001:4860:4860::8844"
    }
    "3" {
        Set-DnsClientServerAddress -InterfaceAlias $interface.Name -ResetServerAddresses
        Write-Host "DNS resetado para o padrão do provedor!" -ForegroundColor Green
        return
    }
    Default { Write-Host "Opção inválida."; return }
}

# Aplicando IPv4
Set-DnsClientServerAddress -InterfaceAlias $interface.Name -ServerAddresses $v4
# Aplicando IPv6
Set-DnsClientServerAddress -InterfaceAlias $interface.Name -ServerAddresses $v6 -AddressFamily IPv6

Write-Host "Sucesso! DNS atualizado." -ForegroundColor Green
ipconfig /flushdns