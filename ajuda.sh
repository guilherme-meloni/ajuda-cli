#!/usr/bin/env bash
# shellcheck disable=SC2059,SC2155
#
#  █████╗ ██████╗ ██████╗  █████╗     ██████╗ ██╗      █████╗
# ██╔══██╗██╔══██╗██╔══██╗██╔══██╗    ██╔══██╗██║     ██╔══██╗
# ███████║██║  ██║██║  ██║███████║    ██████╔╝██║     ███████║
# ██╔══██║██║  ██║██║  ██║██╔══██║    ██╔══██╗██║     ██╔══██║
# ██║  ██║██████╔╝██████╔╝██║  ██║    ██████╔╝███████╗██║  ██║
# ╚═╝  ╚═╝╚═════╝ ╚═════╝ ╚═╝  ╚═╝    ╚═════╝ ╚══════╝╚═╝  ╚═╝
#
# Um cheatsheet interativo e estiloso para o terminal.
# Autor: Guilherme Meloni (github.com/guilherme-meloni)
# Versão: 3.1 (Conteúdo restaurado)
#
# Requisitos: fzf, Nerd Fonts, Terminal com suporte a True Color
#

set -o pipefail
set -o nounset

#======================================================================
# 🎨 CONFIGURAÇÕES GLOBAIS E CORES (Catppuccin Macchiato - True Color)
#======================================================================

# Cores 24-bit para fidelidade máxima com a paleta Catppuccin.
# Requer um terminal moderno (a maioria hoje em dia tem suporte).
ROSEWATER=$(printf '\e[38;2;244;219;214m')
PINK=$(printf '\e[38;2;245;189;230m')
MAUVE=$(printf '\e[38;2;198;160;246m') # Cor principal para títulos
RED=$(printf '\e[38;2;237;135;150m')
GREEN=$(printf '\e[38;2;166;218;149m')
BLUE=$(printf '\e[38;2;138;173;244m')   # Cor para comandos
LAVENDER=$(printf '\e[38;2;183;189;248m')
TEXT=$(printf '\e[38;2;202;211;245m')   # Cor de texto principal
SUBTEXT0=$(printf '\e[38;2;165;173;203m') # Cor para descrições/comentários
RESET=$(printf '\e[0m')                 # Reseta para a cor padrão

# Ícones da Nerd Fonts
declare -A ICONS=(
    [arch]=''
    [package]='📦'
    [aur]='🧩'
    [system]='🖥️'
    [git]=''
    [zsh]='🔌'
    [yazi]='🚀'
    [tmux]='󰆍'
    [exit]='󰍃'
)

#======================================================================
# 🧱 ESTRUTURA DE DADOS DAS PÁGINAS DE AJUDA
#======================================================================
# Estrutura de dados centralizada. Adicionar/remover/editar
# conteúdo aqui é tudo que você precisa fazer.

declare -A CATEGORIES

CATEGORIES[pacman]="
${BLUE}sudo pacman -Syu${RESET}         ${SUBTEXT0}→ Sincroniza e atualiza o sistema${RESET}
${BLUE}sudo pacman -S <pkg>${RESET}      ${SUBTEXT0}→ Instala um pacote dos repositórios${RESET}
${BLUE}sudo pacman -Rns <pkg>${RESET}    ${SUBTEXT0}→ Remove um pacote e suas dependências órfãs${RESET}
${BLUE}pacman -Ss <term>${RESET}          ${SUBTEXT0}→ Procura por um pacote${RESET}
${BLUE}pacman -Qi <pkg>${RESET}          ${SUBTEXT0}→ Mostra informações de um pacote instalado${RESET}
"
CATEGORIES[aur]="
${BLUE}yay -Syu${RESET}                 ${SUBTEXT0}→ Atualiza tudo (oficial + AUR)${RESET}
${BLUE}yay -S <pkg>${RESET}              ${SUBTEXT0}→ Instala um pacote (repo ou AUR)${RESET}
${BLUE}yay -Rns <pkg>${RESET}            ${SUBTEXT0}→ Remove um pacote e suas dependências${RESET}
${BLUE}yay -Ss <term>${RESET}             ${SUBTEXT0}→ Procura por um pacote no AUR${RESET}
"
CATEGORIES[git]="
${BLUE}git clone <url>${RESET}          ${SUBTEXT0}→ Clona um repositório remoto${RESET}
${BLUE}git status${RESET}               ${SUBTEXT0}→ Exibe o estado da árvore de trabalho${RESET}
${BLUE}git add <file>${RESET}           ${SUBTEXT0}→ Adiciona arquivos ao stage (index)${RESET}
${BLUE}git commit -m \"msg\"${RESET}      ${SUBTEXT0}→ Grava as mudanças no repositório localmente${RESET}
${BLUE}git pull${RESET}                 ${SUBTEXT0}→ Busca e integra mudanças do repositório remoto${RESET}
${BLUE}git push${RESET}                 ${SUBTEXT0}→ Envia os commits locais para o repositório remoto${RESET}
"
CATEGORIES[zsh]="
  ${LAVENDER}fzf (Fuzzy Finder):${RESET}
  ${BLUE}Ctrl+t${RESET}                 ${SUBTEXT0}→ Busca arquivos e insere no prompt${RESET}
  ${BLUE}Ctrl+r${RESET}                 ${SUBTEXT0}→ Busca no histórico de comandos${RESET}
  ${BLUE}Alt+c${RESET}                  ${SUBTEXT0}→ Navega para um diretório (fuzzy find)${RESET}

  ${LAVENDER}zoxide (Navegação Inteligente):${RESET}
  ${BLUE}z <term>${RESET}                ${SUBTEXT0}→ Vai para o diretório mais acessado correspondente${RESET}
  ${BLUE}zi${RESET}                     ${SUBTEXT0}→ Abre menu interativo para selecionar o diretório${RESET}
"
CATEGORIES[yazi]="
  ${LAVENDER}Navegação (h,j,k,l ou setas):${RESET}
  ${BLUE}h ou ←${RESET}                 ${SUBTEXT0}→ Pasta pai${RESET}
  ${BLUE}l ou →${RESET}                 ${SUBTEXT0}→ Entra na pasta / abre arquivo${RESET}
  
  ${LAVENDER}Operações com Arquivos:${RESET}
  ${BLUE}y${RESET}                      ${SUBTEXT0}→ Copia (yank)${RESET}
  ${BLUE}d${RESET}                      ${SUBTEXT0}→ Corta (delete)${RESET}
  ${BLUE}p${RESET}                      ${SUBTEXT0}→ Cola${RESET}
  ${BLUE}r${RESET}                      ${SUBTEXT0}→ Renomeia${RESET}
  ${BLUE}. (ponto)${RESET}              ${SUBTEXT0}→ Mostra/esconde arquivos ocultos${RESET}
"
CATEGORIES[tmux]="
  ${LAVENDER}Gerenciamento de Sessões:${RESET}
  ${BLUE}tmux new -s <nome>${RESET}     ${SUBTEXT0}→ Cria e anexa a uma nova sessão${RESET}
  ${BLUE}tmux ls${RESET}                ${SUBTEXT0}→ Lista sessões ativas${RESET}
  ${BLUE}tmux attach -t <nome>${RESET}  ${SUBTEXT0}→ Anexa a uma sessão existente${RESET}
  ${BLUE}tmux kill-session -t <nome>${RESET} ${SUBTEXT0}→ Mata uma sessão específica${RESET}

  ${LAVENDER}Dentro do Tmux (Prefixo: Ctrl+b):${RESET}
  ${BLUE}Ctrl+b %${RESET}               ${SUBTEXT0}→ Divide o painel verticalmente${RESET}
  ${BLUE}Ctrl+b \"${RESET}               ${SUBTEXT0}→ Divide o painel horizontalmente${RESET}
  ${BLUE}Ctrl+b <setas>${RESET}         ${SUBTEXT0}→ Navega entre os painéis${RESET}
  ${BLUE}Ctrl+b d${RESET}               ${SUBTEXT0}→ Desanexa da sessão atual${RESET}
"
CATEGORIES[system]="
${BLUE}fastfetch${RESET}                ${SUBTEXT0}→ Mostra informações gerais do sistema${RESET}
${BLUE}htop${RESET}                     ${SUBTEXT0}→ Monitor de processos interativo${RESET}
${BLUE}free -h${RESET}                  ${SUBTEXT0}→ Exibe uso de memória (RAM e swap)${RESET}
${BLUE}df -h${RESET}                    ${SUBTEXT0}→ Exibe uso de espaço em disco${RESET}
${BLUE}uptime -p${RESET}                ${SUBTEXT0}→ Mostra há quanto tempo o sistema está ativo${RESET}
"

# Títulos e ícones para o menu (mapeados pelas chaves de CATEGORIES)
declare -A PAGE_CONFIG=(
    [pacman]="${ICONS[package]} Pacman - Pacotes Oficiais"
    [aur]="${ICONS[aur]} AUR - yay"
    [git]="${ICONS[git]} Git - Controle de Versão"
    [zsh]="${ICONS[zsh]} ZSH - Plugins & Atalhos"
    [yazi]="${ICONS[yazi]} Yazi - Gerenciador de Arquivos"
    [tmux]="${ICONS[tmux]} Tmux - Multiplexador"
    [system]="${ICONS[system]} System - Informações"
)

#======================================================================
# ⚙️ FUNÇÕES CORE
#======================================================================

function check_dependencies() {
    if ! command -v fzf &> /dev/null; then
        echo -e "${RED}Erro: 'fzf' não encontrado.${RESET}" >&2
        echo -e "${TEXT}Por favor, instale o fzf para rodar este script.${RESET}" >&2
        exit 1
    fi
}

function display_page() {
    local category_key="$1"
    clear
    printf "${MAUVE}%s${RESET}\n\n" "${PAGE_CONFIG[$category_key]}"
    printf "%b" "${CATEGORIES[$category_key]}"
}

function main_menu() {
    local options
    # Gera as opções do menu dinamicamente a partir das chaves de PAGE_CONFIG
    for key in "${!PAGE_CONFIG[@]}"; do
        options+="${PAGE_CONFIG[$key]}\n"
    done
    options+="${RED}${ICONS[exit]} Sair${RESET}"

    local selection=$(printf "%b" "$options" | fzf \
        --prompt " ${MAUVE}Selecione uma categoria > ${RESET}" \
        --height="~50%" \
        --border=rounded \
        --header " ${TEXT}AJUDA CLI ${ICONS[arch]}${RESET}" \
        --pointer=" " \
        --marker="◉ " \
        --cycle \
        --ansi)

    if [[ -z "$selection" ]]; then # Sai se o usuário pressionar ESC ou Ctrl+C
        return 1
    fi

    if [[ "$selection" == *Sair* ]]; then # Condição de saída do loop
        return 1
    fi
    
    # Itera sobre a configuração para encontrar a chave da categoria selecionada
    for key in "${!PAGE_CONFIG[@]}"; do
        # Compara a seleção (sem códigos de cor) com o título da config
        if [[ "$(echo "$selection" | sed 's/\x1b\[[0-9;]*m//g')" == "$(echo "${PAGE_CONFIG[$key]}" | sed 's/\x1b\[[0-9;]*m//g')" ]]; then
            display_page "$key"
            printf "\n\n${SUBTEXT0}[ Pressione qualquer tecla para voltar ao menu ]${RESET}"
            read -n 1 -s -r
            return 0 # Retorna 0 para continuar o loop
        fi
    done
}

#======================================================================
# 🚀 EXECUÇÃO PRINCIPAL
#======================================================================

check_dependencies

while main_menu; do
    : # O loop continua enquanto main_menu retornar 0 (sucesso)
done

clear
printf "${GREEN}Até logo!${RESET}\n"
exit 0