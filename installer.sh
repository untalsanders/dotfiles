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

# DOTFILES_DIR
# The directory where the dotfiles will be installed.
DOTFILES_DIR="${DOTFILES_DIR-}"

# Default install directory
dotfiles_get_dir() {
    [ -z "${DOTFILES_DIR}" ] && printf %s"\n" "${HOME}/.dotfiles"
}

dotfiles_set_install_dir() {
    if [ -n "${DOTFILES_DIR}" ]; then
        printf %s"\n" "${DOTFILES_DIR}"
    else
        printf %s"\n" "$(dotfiles_get_dir)"
    fi
}

dotfiles_do_install() {
    local INSTALL_DIR
    INSTALL_DIR="$(dotfiles_set_install_dir)"

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

    # Adds alias to .zshrc or .bashrc
    if [ -f "${HOME}/.zshrc" ]; then
        echo "👉 Adding alias to .zshrc..."
        echo -e "\n# Dotfiles alias" >> "${HOME}/.zshrc"
        echo "alias dotfiles='git --git-dir=\"${INSTALL_DIR}\" --work-tree=\"${HOME}\"'" >> "${HOME}/.zshrc"
    fi
}

dotfiles_do_install

} # This ensures the entire script is downloaded #
