#!/bin/bash

echo "=== Instalando Ferramentas de Recon (Subfinder + Httpx + Amass) ==="

# Verificar root
if [ "$EUID" -ne 0 ]; then
  echo "Por favor, execute como root ou use sudo"
  exit 1
fi

# Atualizar sistema
apt update -qq

# Instalar dependências
apt install -y curl wget git

# Instalar Go (caso não esteja instalado)
if ! command -v go &> /dev/null; then
    echo "Go não encontrado. Instalando Go..."
    GO_VERSION="1.24.0"
    wget -q https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz
    rm -rf /usr/local/go && tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz
    echo 'export PATH=$PATH:/usr/local/go/bin' >> /etc/profile
    echo 'export PATH=$PATH:$HOME/go/bin' >> /etc/profile
    rm go${GO_VERSION}.linux-amd64.tar.gz
    echo "Go instalado com sucesso!"
fi

# Recarregar PATH
source /etc/profile

# Instalar Subfinder
echo "Instalando Subfinder..."
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest

# Instalar Httpx
echo "Instalando Httpx..."
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest

# Instalar Amass
echo "Instalando Amass..."
go install -v github.com/owasp-amass/amass/v4/...@latest

# Criar links simbólicos em /usr/local/bin
ln -sf $HOME/go/bin/subfinder /usr/local/bin/subfinder 2>/dev/null
ln -sf $HOME/go/bin/httpx /usr/local/bin/httpx 2>/dev/null
ln -sf $HOME/go/bin/amass /usr/local/bin/amass 2>/dev/null

# Verificação das instalações
echo ""
echo "=== Verificação das Instalações ==="

echo "Subfinder:"
subfinder -version

echo ""
echo "Httpx:"
httpx -version

echo ""
echo "Amass:"
amass -version

echo ""
echo "Caminhos das ferramentas:"
echo "Subfinder → $(which subfinder)"
echo "Httpx     → $(which httpx)"
echo "Amass     → $(which amass)"

echo ""
echo "✅ Instalação concluída com sucesso!"
echo "As três ferramentas estão disponíveis globalmente."
