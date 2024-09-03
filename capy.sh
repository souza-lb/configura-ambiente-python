#!/usr/bin/env bash

# Pergunta o nome do ambiente
read -p "Digite o nome do ambiente virtual: " nome_ambiente

# Pergunta a localização desejada
read -p "Digite a localização onde o ambiente será criado (por exemplo, /caminho/para/local): " local_ambiente

# Monta o caminho completo do ambiente
caminho_ambiente="${local_ambiente}/${nome_ambiente}"

# Verifica se o ambiente já existe
if [ -d "$caminho_ambiente" ]; then
    echo "Já existe um ambiente virtual com o nome '${nome_ambiente}' no local '${local_ambiente}'."
    
    # Primeira confirmação
    read -p "Deseja realmente remover o ambiente existente? (S para sim, qualquer outra tecla para não): " resposta1
    if [ "$resposta1" == "S" ]; then
        # Segunda confirmação
        read -p "A remoção não poderá ser recuperada. Deseja continuar? (S para sim, qualquer outra tecla para não): " resposta2
        if [ "$resposta2" == "S" ]; then
            echo "Removendo o ambiente virtual existente..."
            rm -rf "$caminho_ambiente"
        else
            echo "Operação cancelada."
            exit 1
        fi
    else
        echo "Operação cancelada."
        exit 1
    fi
fi

# Pergunta se deseja instalar bibliotecas
read -p "Deseja instalar bibliotecas? (se sim, digite uma lista separada por espaços; caso contrário, pressione Enter): " bibliotecas

# Pergunta se o ambiente é para uso no Spyder IDE
read -p "Este ambiente será usado no Spyder IDE? (S para sim, qualquer outra tecla para não): " pergunta_spyder

# Cria o ambiente virtual
echo "Criando o ambiente virtual em ${caminho_ambiente}..."
virtualenv "$caminho_ambiente"

# Ativa o ambiente virtual
source "${caminho_ambiente}/bin/activate"

# Instala as bibliotecas se fornecidas
if [ ! -z "$bibliotecas" ]; then
    echo "Instalando bibliotecas: $bibliotecas"
    pip install $bibliotecas
fi

# Instala o spyder-kernels se for o caso
if [ "$pergunta_spyder" == "S" ]; then
    echo "Instalando spyder-kernels..."
    pip install spyder-kernels==2.4.*
fi

# Cria a pasta src dentro do ambiente
mkdir -p "${caminho_ambiente}/src"

# Muda para a pasta src
cd "${caminho_ambiente}/src"

# Abre o Thunar sem travar o terminal
nohup thunar . &>/dev/null &

echo "O Thunar foi aberto na pasta src."
echo "O ambiente virtual (${nome_ambiente}) foi criado com sucesso. Para trabalhar posteriormente no mesmo ambiente execute:"
echo "source ${caminho_ambiente}/bin/activate"