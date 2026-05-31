#!/bin/bash

echo "=== Instalando Subfinder (ProjectDiscovery) ==="

# Verificar se é root
if [ "$EUID" -ne 0 ]; then
  echo "Por favor, execute como root ou use sudo"
  exit 1
fi

# Atualizar sistema
apt update -qq

# Instalar dependências
apt install -y curl wget git

# Instalar Go (se não estiver instalado)
if ! command -v go &> /dev/null; then
    echo "Go não encontrado. Instalando Go..."
    GO_VERSION="1.24.0"  # Atualize se quiser versão mais recente
    wget -q https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz
    rm -rf /usr/local/go && tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz
    echo 'export PATH=$PATH:/usr/local/go/bin' >> /etc/profile
    echo 'export PATH=$PATH:$HOME/go/bin' >> /etc/profile
    rm go${GO_VERSION}.linux-amd64.tar.gz
fi

# Recarregar PATH
source /etc/profile

# Instalar Subfinder
echo "Instalando Subfinder..."
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest

# Criar link simbólico em /usr/local/bin
if [ -f "$HOME/go/bin/subfinder" ]; then
    ln -sf $HOME/go/bin/subfinder /usr/local/bin/subfinder
    echo "Subfinder instalado com sucesso!"
else
    echo "Falha ao instalar Subfinder"
    exit 1
fi

# Verificar instalação
echo "Versão instalada:"
subfinder -version

echo "Subfinder está disponível em: $(which subfinder)"
