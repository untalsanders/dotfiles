#!/usr/bin/env bash

# Dotfiles v1.0.0
#
# Sanders Gutiérrez
# www.untalsanders.com
# Twitter = @untalsanders

{ # This ensures the entire script is downloaded #

set -euo pipefail

echo
echo "---------------------------------------------------------"
echo "🚀 Welcome to the untalsanders/dotfiles installer!"
echo "---------------------------------------------------------"
echo

dotfiles_default_install_dir() {
    [ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.dotfiles" || printf %s "${XDG_CONFIG_HOME}/dotfiles"
}

dotfiles_install_dir() {
    if [ -n "${DOTFILES_DIR}" ]; then
        printf %s "${DOTFILES_DIR}"
    else
        dotfiles_default_install_dir
    fi
}

dotfiles_do_install() {
    local INSTALL_DIR
    INSTALL_DIR="$(dotfiles_install_dir)"

    echo "📂 Dotfiles will be installed in: ${INSTALL_DIR}"

    if [ -d "${INSTALL_DIR}" ]; then
        echo "🚨 Warning: ${INSTALL_DIR} already exists!"
        read -p "Do you want to continue? [y/N] : " -n 1 -r
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "🛑 Installation aborted!"
            exit 1
        fi
    fi

    mkdir -p "${INSTALL_DIR}"

    echo
    echo "👉 Installing git..."
    command git init --bare "${INSTALL_DIR}"
    
    # Making aliases
    if [ -f "${HOME}/.zshrc" ]; then
        echo "👉 Adding alias to .zshrc..."
        echo "alias dotfiles='git --git-dir=\"${INSTALL_DIR}\" --work-tree=\"${HOME}\"'" >> "${HOME}/.zshrc"
    fi
    
    if [ -f "${HOME}/.bashrc" ]; then
        echo "👉 Adding alias to .bashrc..."
        echo "alias dotfiles='git --git-dir=\"${INSTALL_DIR}\" --work-tree=\"${HOME}\"'" >> "${HOME}/.bashrc"
    fi
}

dotfiles_do_install

} # This ensures the entire script is downloaded #
