#!/bin/bash

echo "==============================="
echo "Gerenciar KVM (para uso com VirtualBox ou outros)"
echo "==============================="
echo
echo "Escolha uma opção:"
echo "1) Desativar KVM TEMPORARIAMENTE (até reiniciar)"
echo "2) Desativar KVM PERMANENTEMENTE (via GRUB)"
echo "3) Ativar KVM TEMPORARIAMENTE (sem reiniciar)"
echo "4) Ativar KVM PERMANENTEMENTE (via GRUB)"
echo "0) Cancelar"
echo

read -p "Opção: " opt

# Detecta o tipo de CPU
CPU_VENDOR=$(lscpu | grep -i "Vendor ID" | awk '{print $3}')
if [[ $CPU_VENDOR == "GenuineIntel" ]]; then
  MODULE="kvm_intel"
  KVM_OPTION="kvm_intel.blacklist=yes kvm.blacklist=yes"
  REMOVE_KVM_OPTION="kvm_intel.blacklist=yes kvm.blacklist=yes"
elif [[ $CPU_VENDOR == "AuthenticAMD" ]]; then
  MODULE="kvm_amd"
  KVM_OPTION="kvm_amd.blacklist=yes kvm.blacklist=yes"
  REMOVE_KVM_OPTION="kvm_amd.blacklist=yes kvm.blacklist=yes"
else
  echo "[-] Não foi possível identificar o tipo de CPU (Intel ou AMD). Abortando."
  exit 1
fi

case $opt in
  1)
    echo "[+] Removendo módulos KVM..."
    sudo rmmod $MODULE 2>/dev/null
    sudo rmmod kvm 2>/dev/null
    echo "[✓] KVM desativado temporariamente."
    ;;
  2)
    echo "[+] Atualizando GRUB para desativar KVM permanentemente..."
    sudo sed -i "/^GRUB_CMDLINE_LINUX_DEFAULT=/ s/\"$/ $KVM_OPTION\"/" /etc/default/grub
    sudo update-grub
    echo "[✓] GRUB atualizado. Reinicie o sistema para aplicar as mudanças."
    ;;
  3)
    echo "[+] Ativando módulos KVM..."
    sudo modprobe kvm
    sudo modprobe $MODULE
    echo "[✓] KVM ativado temporariamente."
    ;;
  4)
    echo "[+] Atualizando GRUB para reativar KVM permanentemente..."
    sudo sed -i "s/ *$REMOVE_KVM_OPTION//g" /etc/default/grub
    sudo update-grub
    echo "[✓] GRUB atualizado. Reinicie o sistema para aplicar as mudanças."
    ;;
  0)
    echo "Cancelado."
    ;;
  *)
    echo "Opção inválida."
    ;;
esac
