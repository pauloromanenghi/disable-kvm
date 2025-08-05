# Gerenciador de KVM para VirtualBox e Outros Hypervisores

Este script Bash permite gerenciar o módulo KVM (Kernel-based Virtual Machine) no Linux, útil especialmente quando se utiliza o **VirtualBox**, que pode apresentar conflitos com o KVM ativado.

## ⚙️ Funcionalidades

O script oferece as seguintes opções:

1. **Desativar KVM temporariamente** (até o próximo reboot).
2. **Desativar KVM permanentemente** (editando o GRUB).
3. **Ativar KVM temporariamente** (sem reiniciar o sistema).
4. **Ativar KVM permanentemente** (removendo o bloqueio do GRUB).
0. **Cancelar**.

## 🧠 Detecção automática do processador

O script detecta se seu processador é Intel ou AMD, e carrega/descarrega os módulos apropriados:
- Intel → `kvm_intel`
- AMD → `kvm_amd`

## 🔧 Requisitos

- Distribuição Linux com suporte a KVM.
- Acesso root (`sudo`).
- Comandos disponíveis: `lscpu`, `rmmod`, `modprobe`, `sed`, `update-grub`.

## 🛠️ Instalação

1. Salve o script como `kvm-manager.sh`:

```bash
chmod +x kvm-manager.sh
```

2. Execute com:

```bash
./kvm-manager.sh
```

> ⚠️ Importante: **Sempre execute com o interpretador Bash** (`./kvm-manager.sh` ou `bash kvm-manager.sh`), pois o script usa `[[ ... ]]`, que não é compatível com `sh`.

## 🚨 Atenção

- A desativação permanente via GRUB exige **reinicialização** para surtir efeito.
- Caso use dual-boot ou múltiplos kernels, a configuração pode precisar ser repetida em cada um.

## 📁 Como funciona

### Desativação Temporária
Remove os módulos KVM da memória do kernel usando `rmmod`.

### Desativação Permanente
Adiciona os parâmetros `kvm_intel.blacklist=yes kvm.blacklist=yes` (ou AMD) na linha de comando do GRUB e executa `update-grub`.

### Ativação Temporária
Carrega os módulos com `modprobe`.

### Ativação Permanente
Remove os parâmetros de blacklist do GRUB.

---

## ✅ Exemplo de uso

```bash
===============================
Gerenciar KVM (para uso com VirtualBox ou outros)
===============================

Escolha uma opção:
1) Desativar KVM TEMPORARIAMENTE (até reiniciar)
2) Desativar KVM PERMANENTEMENTE (via GRUB)
3) Ativar KVM TEMPORARIAMENTE (sem reiniciar)
4) Ativar KVM PERMANENTEMENTE (via GRUB)
0) Cancelar

Opção: 1
[+] Removendo módulos KVM...
[✓] KVM desativado temporariamente.
```

---

## 📜 Licença

Este script é fornecido **sem garantias** e pode ser livremente utilizado e modificado.
