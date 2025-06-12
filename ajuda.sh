#!/bin/bash

#======================================================================
# AJUDA PRO – Menu interativo de comandos para Arch Linux
# Autor: Guilherme (github.com/guilherme-meloni)
# Versão: 2.0 (com fzf, cores e ícones)
# Data: 11/06/2025
# Descrição: Menu interativo com fzf para consulta rápida de comandos.
# Requisitos: fzf, Nerd Fonts
#======================================================================

# ----------------------------------------------------------------------
#  🎨 PALETA DE CORES (CATPPUCCIN MACCHIATO) E ÍCONES 
# ----------------------------------------------------------------------
# Usamos printf para definir cores 24-bit (True Color) no terminal
# Formato: \e[38;2;R;G;Bm (foreground)
# Os valores RGB foram convertidos dos seus hexadecimais.

# Cores
ROSEWATER=$(printf '\e[38;2;244;219;214m')
FLAMINGO=$(printf '\e[38;2;240;198;198m')
PINK=$(printf '\e[38;2;245;189;230m')
MAUVE=$(printf '\e[38;2;198;160;246m') # Cor principal para títulos
RED=$(printf '\e[38;2;237;135;150m')
PEACH=$(printf '\e[38;2;245;169;127m')
YELLOW=$(printf '\e[38;2;238;212;159m')
GREEN=$(printf '\e[38;2;166;218;149m')
BLUE=$(printf '\e[38;2;138;173;244m')   # Cor para comandos
LAVENDER=$(printf '\e[38;2;183;189;248m')
TEXT=$(printf '\e[38;2;202;211;245m')   # Cor de texto principal
SUBTEXT0=$(printf '\e[38;2;165;173;203m') # Cor para descrições/comentários
RESET=$(printf '\e[0m')                 # Reseta para a cor padrão

# Ícones (copiados da Nerd Fonts Cheat Sheet)
ICON_ARCH=''
ICON_PACKAGE='📦'
ICON_AUR='🧩'
ICON_INFO='🖥️'
ICON_FILES='📂'
ICON_NETWORK='🌐'
ICON_GIT=''
ICON_SERVICE='🛠️'
ICON_CONFIG='🔧'
ICON_ZSH='🔌'
ICON_YAZI='🚀'
ICON_TMUX='󰆍'
ICON_EXIT='󰍃'

# ----------------------------------------------------------------------
#   FUNÇÕES PARA CADA SEÇÃO (AS "PÁGINAS")
# ----------------------------------------------------------------------
# Cada função exibe uma categoria de ajuda.

show_pacman() {
    clear
    echo -e "${MAUVE}${ICON_PACKAGE} Pacman (repositórios oficiais):${RESET}"
    echo -e "${BLUE}sudo pacman -Syu${RESET}         ${SUBTEXT0}→ Atualiza o sistema${RESET}"
    echo -e "${BLUE}sudo pacman -S nome${RESET}      ${SUBTEXT0}→ Instala pacote${RESET}"
    echo -e "${BLUE}sudo pacman -Rns nome${RESET}    ${SUBTEXT0}→ Remove pacote + dependências${RESET}"
    echo -e "${BLUE}pacman -Ss nome${RESET}          ${SUBTEXT0}→ Procura pacote no repositório${RESET}"
    echo -e "${BLUE}pacman -Qi nome${RESET}          ${SUBTEXT0}→ Informações de um pacote${RESET}"
}

show_aur() {
    clear
    echo -e "${MAUVE}${ICON_AUR} AUR (com yay):${RESET}"
    echo -e "${BLUE}yay -Syu${RESET}                 ${SUBTEXT0}→ Atualiza tudo (oficial + AUR)${RESET}"
    echo -e "${BLUE}yay -S nome${RESET}              ${SUBTEXT0}→ Instala pacote da AUR${RESET}"
    echo -e "${BLUE}yay -Rns nome${RESET}            ${SUBTEXT0}→ Remove pacote da AUR${RESET}"
    echo -e "${BLUE}yay -Ss nome${RESET}             ${SUBTEXT0}→ Busca na AUR${RESET}"
}

show_git() {
    clear
    echo -e "${MAUVE}${ICON_GIT} GitHub – Controle de Versão:${RESET}"
    echo -e "${BLUE}git clone <url>${RESET}          ${SUBTEXT0}→ Baixa um repositório da internet${RESET}"
    echo -e "${BLUE}git status${RESET}               ${SUBTEXT0}→ Mostra o estado atual do repositório${RESET}"
    echo -e "${BLUE}git add .${RESET}                ${SUBTEXT0}→ Prepara todos os arquivos para o commit${RESET}"
    echo -e "${BLUE}git commit -m \"msg\"${RESET}      ${SUBTEXT0}→ Salva as alterações localmente${RESET}"
    echo -e "${BLUE}git pull${RESET}                 ${SUBTEXT0}→ Puxa (baixa) atualizações do remoto${RESET}"
    echo -e "${BLUE}git push${RESET}                 ${SUBTEXT0}→ Envia seus commits para o remoto${RESET}"
    echo -e "${BLUE}git log --oneline${RESET}        ${SUBTEXT0}→ Vê o histórico de commits de forma simples${RESET}"
}

show_zsh() {
    clear
    echo -e "${MAUVE}${ICON_ZSH} Plugins ZSH – Produtividade no terminal:${RESET}"
    echo -e "${TEXT}Comandos e atalhos dos seus plugins:${RESET}"
    echo ""
    echo -e "  ${LAVENDER}fzf (Fuzzy Finder):${RESET}"
    echo -e "  ${BLUE}Ctrl+t${RESET}                 ${SUBTEXT0}→ Busca arquivos e insere no comando${RESET}"
    echo -e "  ${BLUE}Ctrl+r${RESET}                 ${SUBTEXT0}→ Busca no histórico de comandos${RESET}"
    echo -e "  ${BLUE}Alt+c${RESET}                  ${SUBTEXT0}→ Entra em uma pasta (fuzzy find)${RESET}"
    echo ""
    echo -e "  ${LAVENDER}zoxide (Navegação inteligente):${RESET}"
    echo -e "  ${BLUE}z <parte_do_nome>${RESET}      ${SUBTEXT0}→ Vai para a pasta mais acessada (ex: z doc)${RESET}"
    echo -e "  ${BLUE}zi${RESET}                     ${SUBTEXT0}→ Abre um menu interativo (com fzf) para escolher a pasta${RESET}"
    echo ""
    echo -e "  ${LAVENDER}Plugin Git (atalhos comuns):${RESET}"
    echo -e "  ${BLUE}ga .${RESET}                   ${SUBTEXT0}→ git add .${RESET}"
    echo -e "  ${BLUE}gc -m \"msg\"${RESET}           ${SUBTEXT0}→ git commit -m \"msg\"${RESET}"
    echo -e "  ${BLUE}gp${RESET}                     ${SUBTEXT0}→ git push${RESET}"
    echo -e "  ${BLUE}gst${RESET}                    ${SUBTEXT0}→ git status${RESET}"
}

show_yazi() {
    clear
    echo -e "${MAUVE}${ICON_YAZI} Yazi – Gerenciador de Arquivos Rápido:${RESET}"
    echo -e "${LAVENDER}Navegação básica (use as setas ou h,j,k,l):${RESET}"
    echo -e "  ${BLUE}h ou ←${RESET}                 ${SUBTEXT0}→ Vai para a pasta pai${RESET}"
    echo -e "  ${BLUE}l ou →${RESET}                 ${SUBTEXT0}→ Entra na pasta ou abre o arquivo${RESET}"
    echo -e "  ${BLUE}j ou ↓${RESET}                 ${SUBTEXT0}→ Move o cursor para baixo${RESET}"
    echo -e "  ${BLUE}k ou ↑${RESET}                 ${SUBTEXT0}→ Move o cursor para cima${RESET}"
    echo ""
    echo -e "  ${LAVENDER}Operações com arquivos:${RESET}"
    echo -e "  ${BLUE}y${RESET}                      ${SUBTEXT0}→ Copia o arquivo selecionado${RESET}"
    echo -e "  ${BLUE}d${RESET}                      ${SUBTEXT0}→ Marca para deletar (corta)${RESET}"
    echo -e "  ${BLUE}p${RESET}                      ${SUBTEXT0}→ Cola os arquivos copiados/cortados${RESET}"
    echo -e "  ${BLUE}r${RESET}                      ${SUBTEXT0}→ Renomeia o arquivo selecionado${RESET}"
    echo -e "  ${BLUE}.${RESET} (ponto)              ${SUBTEXT0}→ Alterna a exibição de arquivos ocultos${RESET}"
    echo -e "  ${BLUE}\" \"${RESET} (espaço)           ${SUBTEXT0}→ Seleciona múltiplos arquivos${RESET}"
    echo ""
    echo -e "  ${LAVENDER}Abas e pesquisa:${RESET}"
    echo -e "  ${BLUE}Tab${RESET}                    ${SUBTEXT0}→ Alterna entre as abas do Yazi${RESET}"
    echo -e "  ${BLUE}/${RESET}                      ${SUBTEXT0}→ Inicia o modo de pesquisa${RESET}"
    echo -e "  ${BLUE}q${RESET}                      ${SUBTEXT0}→ Fecha o Yazi${RESET}"
}

show_system() {
    clear
    echo -e "${MAUVE}${ICON_INFO} Informações do sistema:${RESET}"
    echo -e "${BLUE}fastfetch${RESET}                ${SUBTEXT0}→ Mostra informações gerais${RESET}"
    echo -e "${BLUE}htop${RESET}                     ${SUBTEXT0}→ Monitor de tarefas (interativo)${RESET}"
    echo -e "${BLUE}free -h${RESET}                  ${SUBTEXT0}→ Uso de memória RAM e swap${RESET}"
    echo -e "${BLUE}df -h${RESET}                    ${SUBTEXT0}→ Espaço em disco${RESET}"
    echo -e "${BLUE}uptime${RESET}                   ${SUBTEXT0}→ Tempo de atividade do sistema${RESET}"
}

show_tmux() {
    clear
    echo -e "${MAUVE}${ICON_TMUX} Multiplexador de Terminal (tmux):${RESET}"
    echo -e "${TEXT}  Sessões = Projetos | Janelas = Abas | Painéis = Divisões${RESET}"
    echo ""
    echo -e "  ${LAVENDER}FORA do tmux (gerenciar sessões):${RESET}"
    echo -e "  ${BLUE}tmux new -s <nome>${RESET}     ${SUBTEXT0}→ Cria e entra em uma nova sessão${RESET}"
    echo -e "  ${BLUE}tmux ls${RESET}                ${SUBTEXT0}→ Lista todas as sessões ativas${RESET}"
    echo -e "  ${BLUE}tmux attach -t <nome>${RESET}  ${SUBTEXT0}→ Anexa (entra) em uma sessão existente${RESET}"
    echo ""
    echo -e "  ${LAVENDER}DENTRO do tmux (atalhos com o prefixo 'Ctrl + b'):${RESET}"
    echo -e "  ${BLUE}Ctrl+b %${RESET}               ${SUBTEXT0}→ Divide a tela na VERTICAL${RESET}"
    echo -e "  ${BLUE}Ctrl+b \"${RESET}               ${SUBTEXT0}→ Divide a tela na HORIZONTAL${RESET}"
    echo -e "  ${BLUE}Ctrl+b <setas>${RESET}         ${SUBTEXT0}→ Navega entre os painéis${RESET}"
    echo -e "  ${BLUE}Ctrl+b d${RESET}               ${SUBTEXT0}→ Desanexa da sessão (deixa rodando)${RESET}"
    echo -e "  ${BLUE}Ctrl+b c${RESET}               ${SUBTEXT0}→ Cria uma nova janela (aba)${RESET}"
    echo -e "  ${BLUE}Ctrl+b w${RESET}               ${SUBTEXT0}→ Lista as janelas de forma interativa${RESET}"
}

# Adicione aqui outras funções para as seções restantes (Rede, Arquivos, etc.)
# seguindo o mesmo modelo.

# ----------------------------------------------------------------------
#   MENU PRINCIPAL (LOOP COM FZF)
# ----------------------------------------------------------------------
while true; do
    # Lista de opções para o fzf
    options="${ICON_PACKAGE} Pacman - Pacotes Oficiais\n"
    options+="${ICON_AUR} AUR - Repositório Comunitário\n"
    options+="${ICON_ZSH} ZSH - Plugins e Atalhos\n"
    options+="${ICON_YAZI} Yazi - Gerenciador de Arquivos\n"
    options+="${ICON_GIT} Git - Controle de Versão\n"
    options+="${ICON_TMUX} Tmux - Multiplexador de Terminal\n"
    options+="${ICON_INFO} System - Informações do Sistema\n"
    options+="${RED}${ICON_EXIT} Sair${RESET}"

    # O fzf cria o menu. Usamos --ansi para que ele mostre as cores e ícones.
    # A seleção do usuário é guardada na variável 'selection'
    selection=$(echo -e "$options" | fzf \
        --prompt " ${MAUVE} Selecione uma categoria > ${RESET}" \
        --height="~50%" \
        --border=rounded \
        --header " ${TEXT}AJUDA RÁPIDA DE COMANDOS ${ICON_ARCH}${RESET}" \
        --pointer=" " \
        --marker="◉ " \
        --cycle \
        --ansi)

    # O 'case' verifica a escolha do usuário e chama a função correspondente
    # Usamos '*' no final para ignorar as cores e focar no texto da opção
    case "$selection" in
        *"Pacman"*)
            show_pacman
            ;;
        *"AUR"*)
            show_aur
            ;;
        *"ZSH"*)
            show_zsh
            ;;
        *"Yazi"*)
            show_yazi
            ;;
        *"Git"*)
            show_git
            ;;
        *"Tmux"*)
            show_tmux
            ;;
        *"System"*)
            show_system
            ;;
        *"Sair"*)
            clear
            break # Quebra o loop e encerra o script
            ;;
    esac

    # Pede para o usuário pressionar uma tecla para voltar ao menu principal
    # Isso só acontece se uma categoria foi exibida (e não se "Sair" foi escolhido)
    if [[ -n "$selection" ]]; then
        echo -e "\n${SUBTEXT0}[ Pressione qualquer tecla para voltar ao menu ]${RESET}"
        read -n 1 -s -r
    fi
done

echo -e "${GREEN}Até logo!${RESET}"