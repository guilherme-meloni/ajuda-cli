# AJUDA CLI

> Diga adeus ao Google para lembrar comandos de terminal.

Um cheatsheet interativo e ultrarrápido, diretamente no seu terminal, com a estética que você merece.

<p align="center">
  <img src="https://img.shields.io/badge/licen%C3%A7a-MIT-blue.svg" alt="Licença MIT">
  <img src="https://img.shields.io/badge/shell-BASH-brightgreen" alt="Feito em Bash">
  <img src="https://img.shields.io/badge/prereq-fzf-orange" alt="Requer fzf">
</p>

---

## 📋 Tabela de Conteúdos

* [🤯 O Problema](#-o-problema)
* [💡 A Solução](#-a-solução)
* [✨ Features](#-features)
* [🔧 Pré-requisitos](#-pré-requisitos)
* [🚀 Instalação](#-instalação)
* [🎮 Como Usar](#-como-usar)
* [🎨 Customização](#-customização)
* [💖 Agradecimentos e Licenças](#-agradecimentos-e-licenças)

## 🤯 O Problema

`pacman -Rns` ou `-Rsc`? Qual era mesmo o atalho do `tmux` para dividir a tela na vertical? `git reset` ou `git revert`?

A vida no terminal exige que a gente memorize centenas de comandos e flags. Buscar no Google ou no `man` toda vez quebra o fluxo de trabalho e consome um tempo precioso.

## 💡 A Solução

**AJUDA CLI** é a sua memória externa para o terminal. Um script de shell simples e poderoso que organiza todos os seus comandos úteis em um menu pesquisável com `fzf`. É a forma mais rápida de consultar aquela "colinha" sem sair do seu ambiente de trabalho, mantendo o foco e a produtividade.

Tudo isso com uma interface limpa, ícones informativos e a belíssima paleta de cores [Catppuccin Macchiato](https://github.com/catppuccin/catppuccin).

## ✨ Features

* **Busca Instantânea:** Interface com `fzf` para encontrar o que você precisa em milissegundos.
* **Arquitetura Data-Driven:** Adicione novas seções de comandos (ex: docker, k8s) editando apenas um array de texto. A lógica do script se adapta sozinha.
* **Visual Impecável:** Cores vibrantes em True Color (24-bit) e ícones da Nerd Fonts que guiam o olhar.
* **Leve e Rápido:** Um único script em Bash, sem dependências pesadas ou lentidão.
* **Robusto:** Checagem de dependências na inicialização para evitar erros inesperados.

## 🔧 Pré-requisitos

* **[fzf](https://github.com/junegunn/fzf):** Para a interface de busca.
    ```bash
    # Arch Linux
    sudo pacman -S fzf
    # Debian/Ubuntu
    sudo apt install fzf
    
    ```
* **[Nerd Fonts](https://www.nerdfonts.com/):** Para a correta exibição dos ícones. Recomendo a **FiraCode Nerd Font**.
* **Terminal com Suporte a True Color:** Essencial para a paleta de cores. (Ex: Kitty, Alacritty, WezTerm, Windows Terminal).

## 🚀 Instalação

1.  **Clone o repositório:**
    ```bash
    git clone [https://github.com/guilherme-meloni/ajuda-cli.git](https://github.com/guilherme-meloni/ajuda-cli.git)
    cd ajuda-cli
    ```

2.  **Dê permissão de execução:**
    ```bash
    chmod +x ajuda-cli.sh
    ```

3.  **Crie um alias (Recomendado):** Adicione a linha abaixo ao seu `.zshrc` ou `.bashrc` para chamar o script de qualquer lugar.

    **Importante:** Lembre-se de usar o caminho absoluto para o script.
    ```bash
    # Substitua "/caminho/completo/para" pelo caminho real no seu sistema
    alias ajuda="/caminho/completo/para/ajuda-cli/ajuda-cli.sh"
    ```

## 🎮 Como Usar

Após configurar o alias, simplesmente abra um novo terminal ou atualize o seu atual (`source ~/.zshrc` ou `source ~/.bashrc`) e digite:

```bash
ajuda
```

O menu interativo aparecerá. Digite para buscar e pressione `Enter` para selecionar.

## 🎨 Customização

A arquitetura do script foi pensada para ser modular. Para adicionar uma nova categoria, você só precisa editar dois arrays no início do arquivo `ajuda-cli.sh`, sem tocar na lógica.

1.  **Adicione o conteúdo ao array `CATEGORIES`:**
    ```bash
    # ... dentro do script ajuda-cli.sh ...

    # ADICIONE SUA NOVA CATEGORIA AQUI
    CATEGORIES[docker]="
    ${BLUE}docker ps${RESET}                ${SUBTEXT0}→ Lista containers em execução${RESET}
    ${BLUE}docker ps -a${RESET}              ${SUBTEXT0}→ Lista todos os containers${RESET}
    ${BLUE}docker images${RESET}             ${SUBTEXT0}→ Lista as imagens locais${RESET}
    "
    ```

2.  **Adicione o título e o ícone ao array `PAGE_CONFIG`:**
    ```bash
    # Opcional: adicione um novo ícone ao array ICONS
    ICONS[docker]='🐳'

    # Adicione a configuração da página
    declare -A PAGE_CONFIG=(
        [system]="${ICONS[system]} System - Informações" # Config existente
        
        # ADICIONE SUA NOVA CONFIGURAÇÃO AQUI
        [docker]="${ICONS[docker]} Docker - Containers"
    )
    ```
Pronto! A nova categoria aparecerá no menu na próxima vez que você rodar o script.

## 💖 Agradecimentos e Licenças

Este projeto é construído sobre os ombros de gigantes. Todo o crédito e agradecimento aos criadores das ferramentas e temas que tornam o AJUDA CLI possível.

* **O Projeto:** `ajuda-cli` é distribuído sob a [Licença MIT](./LICENSE).
* **fzf:** O motor de busca interativo é o [fzf](https://github.com/junegunn/fzf), criado por Junegunn Choi e também licenciado sob a Licença MIT.
* **Catppuccin:** A paleta de cores é a [Catppuccin Macchiato](https://github.com/catppuccin/catppuccin), um projeto de código aberto fantástico, distribuído sob a Licença MIT.

---