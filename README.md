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
