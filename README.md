# 🚀 DNS Turbocharger

Uma guia de referência rápida para otimizar sua resolução de nomes utilizando os provedores mais rápidos e seguros do mercado (**Cloudflare** & **Google**).

## ⚡ Por que trocar seu DNS?

Muitas vezes, o DNS padrão do seu provedor de internet (ISP) é lento ou instável. Mudar para um resolvedor de alto desempenho pode:

* **Reduzir a latência** em jogos e navegação.
* **Aumentar a privacidade** (menos rastreamento do ISP).
* **Melhorar a segurança** contra ataques de phishing.

---

## 🛠️ Configuração no Windows (Passo a Passo)

1. Abra as **Configurações do Windows** > **Rede e Internet**.
2. Clique em **Alterar opções do adaptador**.
3. Clique com o botão direito na sua conexão ativa e selecione **Propriedades**.
4. Localize e selecione **Protocolo IP Versão 4 (TCP/IPv4)** e clique em **Propriedades**.
5. Marque "Usar os seguintes endereços de servidor DNS" e insira os IPs abaixo.
6. Repita o processo para o **Protocolo IP Versão 6 (TCP/IPv6)**.

---

## 📋 Tabelas de Referência

### 🧡 Cloudflare (Foco em Velocidade & Privacidade)

Ideal para quem busca o menor tempo de resposta possível.

| Protocolo | Servidor Preferencial | Servidor Alternativo |
| --- | --- | --- |
| **IPv4** | `1.1.1.1` | `1.0.0.1` |
| **IPv6** | `2606:4700:4700::1111` | `2606:4700:4700::1001` |

### 💙 Google Public DNS (Foco em Resiliência)

A infraestrutura global mais robusta do planeta.

| Protocolo | Servidor Preferencial | Servidor Alternativo |
| --- | --- | --- |
| **IPv4** | `8.8.8.8` | `8.8.4.4` |
| **IPv6** | `2001:4860:4860::8888` | `2001:4860:4860::8844` |

> [!TIP]
> **Dica para IPv6 legas:** Se o seu dispositivo não aceita a sintaxe abreviada (`::`), utilize o formato completo:
> * **Pref:** `2001:4860:4860:0:0:0:0:8888`
> * **Alt:** `2001:4860:4860:0:0:0:0:8844`
> 
> 

---

## 🧪 Como verificar se funcionou?

Após configurar, abra o seu terminal (Powershell ou CMD) e digite:

```bash
nslookup google.com

```

No campo `Server`, deverá aparecer `one.one.one.one` (Cloudflare) ou `dns.google`.

Com certeza! Como um desenvolvedor sênior, eu recomendo automatizar isso via **PowerShell**. É mais moderno que o antigo `.bat`, permite manipular as interfaces de rede de forma precisa e já vem nativo no Windows.

Vou estruturar o script com tratamento de erros e privilégios de administrador, que é o padrão profissional.

---

## 📜 Script de Automação: `Set-DNS.ps1`

Este script identifica sua interface de rede ativa (Wi-Fi ou Ethernet) e aplica as configurações automaticamente.

```powershell
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

```

---

### ⚡ Instalação Rápida (PowerShell)

Se você prefere não fazer o processo manual, utilize nosso script de automação:

1. Abra o **PowerShell** como Administrador.
2. Navegue até a pasta do projeto.
3. Execute o comando:
4. 
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; .\Set-DNS.ps1

```

---

### 🔍 O que esse script faz por baixo dos panos?

Para garantir a transparência, o script:

1. **Valida Permissões:** Checa se você tem poder de escrita no sistema.
2. **Auto-Discovery:** Detecta qual placa de rede você está usando no momento (evita configurar portas virtuais ou VPNs inativas).
3. **Flush DNS:** Limpa o cache do Windows imediatamente para que a nova velocidade já seja sentida no próximo "Enter".
