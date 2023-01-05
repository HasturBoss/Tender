#!/usr/bin/env bash

# Change 'DOWNLOAD_LINK' for you
DOWNLOAD_LINK="https://github.com/HasturBoss/V8ray.git"

# author:HasturBoss
download_git() {
    if [ -d "./V8ray/" ]; then
        echo "The file has been downloaded!"
    else
        git clone "$DOWNLOAD_LINK"
        echo "The file has been downloaded!"
    fi
}

vimrc_config() {
    if [ -f "./V8ray/vimrc.txt" ]; then
        sed "s/<username>/$current_username/g" ./V8ray/vimrc.txt > ./V8ray/vimrc_bak.txt
        # Do not modify
        sed -ni '3,37p' ./V8ray/vimrc_bak.txt
        cat ./V8ray/vimrc_bak.txt >> /home/$current_username/.vim/.vimrc
    else
        echo "error: Download failed! Please check your network or try again."
        exit 1
    fi
}

vim_config() {
    TMP_FILE="$(mktemp)"
    read -p "Please enter your current username: " current_username
    cut -d: -f1 /etc/passwd > $TMP_FILE
    confirm_username="$(grep -o "^$current_username$" $TMP_FILE)"
    "rm" "$TMP_FILE"
    if [ "$confirm_username" = "$current_username" ]; then
        if [ -d "/home/$current_username/.vim" ]; then
            mkdir /home/$current_username/.vim/plugin \
            /home/$current_username/.vim/plugin/ycm
            if [ -f "/home/$current_username/.vim/.vimrc" ]; then
                echo 'warning: This file exist.'
                vimrc_config
            else
                ln -s /usr/share/vim/vimrc /home/$current_username/.vim/.vimrc
                vimrc_config
            fi
        else
            mkdir /home/$current_username/.vim \
            /home/$current_username/.vim/plugin \
            /home/$current_username/.vim/plugin/ycm
            ln -s /usr/share/vim/vimrc /home/$current_username/.vim/.vimrc
            vimrc_config
        fi
    else
        echo "Username does not exist!"
        exit 1
    fi
}

ycm_extra_conf() {
    if [ -f "./V8ray/ycm_extra_conf.txt" ]; then
        local var=1
        while (( $var<=99 ))
        do
            if [ -d "/usr/lib/gcc/x86_64-linux-gnu/$var" -a "/usr/include/c++/$var"]; then
                sed "s/9/$var/g" ./V8ray/ycm_extra_conf.txt > ./V8ray/ycm_extra_conf_bak.txt
                cat ./V8ray/ycm_extra_conf_bak.txt > /home/$current_username/.vim/plugin/ycm/third_party/ycmd/examples/.ycm_extra_conf.py
                echo "The .ycm_extra_conf.py is edited!"
            else
                echo "The clangd folder does not exist!"
                exit 1
            fi
        done
    else
        echo "error: Download failed! Please check your network or try again."
        exit 1
    fi
}

clangd_config() {
    echo "\033[31m<Must be executed with root privileges>\033[0m"
    echo 'Please confirm the version, vim-plug,CMake(at least 3.13), Vim(at least 8.1.2269) and Python(at least 3.6)'
    read -p "Please input y or n, Y or N: " char
    if [ $char = "y" -o $char = "Y" ]; then
        apt install build-essential cmake clangd python3-dev vim-nox
        python3 ./V8ray/vim-language-server/install.py --clangd-complete
        cp -rf ./V8ray/vim-language-server/* /home/$current_username/.vim/plugin/ycm
        echo "\033[31mEdit /home/<username>/.vim/plugin/ycm/third_party/ycmd/examples/.ycm_extra_conf.py\033[0m"
        ycm_extra_conf
    elif [ $char = "n" -o $char = "N" ]; then
        return 1
    else
        echo "The invalid symbol!"
        return 1
    fi
}

nerdtree_config() {
    echo "Please confirm the Vim is installed!"
    read -p "Please input y or n, Y or N: " char
    if [ $char = "y" -o $char = "Y" ]; then
        cp -f ./V8ray/vim-plugin-nerdtree/plugin/NERD_tree.vim /home/$current_username/.vim/plugin
        cp -f ./V8ray/vim-plugin-nerdtree/doc/NERDTree.txt /home/$current_username/.vim/plugin
    elif [ $char = "n" -o $char = "N" ]; then
        return 1
    else
        echo "The invalid symbol!"
        return 1
    fi
}

plugin_config() {
    echo "Please confirm the Vim is installed!"
    read -p "Please input y or n, Y or N: " char
    if [ $char = "y" -o $char = "Y" ]; then
        cp -f ./V8ray/vim-plugin-package/plug.vim /home/$current_username/.vim/plugin
        cp -f ./V8ray/vim-plugin-package/doc/plug.txt /home/$current_username/.vim/plugin
    elif [ $char = "n" -o $char = "N" ]; then
        return 1
    else
        echo "The invalid symbol!"
        return 1
    fi
}

detection_agent() {
    env | grep proxy
    unset  http_proxy
    unset  https_proxy
    apt update
    apt upgrade
}

use_parameters() {
    while [[ "$#" -gt '0' ]]; do
        case "$1" in
            '-a' | '--all')
                ALL='1'
                break
                ;;
            '-c' | '--clangd')
                CLANGD='1'
                break
                ;;
            '-n' | '--nerdtree')
                NERDTREE='1'
                break
                ;;
            '-p' | '--plugin')
                PLUGIN='1'
                break
                ;;
            '-h' | '--help')
                HELP='1'
                break
                ;;
            *)
                echo "$0: unknown option -- -"
                exit 1
                ;;
        esac
        shift
    done
}

install_clangd() {
    if [ -d "./V8ray/vim-language-server" ]; then
        clangd_config
    else
        echo "error: Download failed! Please check your network or try again."
        exit 1
    fi
}

install_nerdtree() {
    if [ -d "./V8ray/vim-plugin-nerdtree" ]; then
        nerdtree_config
    else
        echo "error: Download failed! Please check your network or try again."
        exit 1
    fi
}

install_plugin() {
    if [ -d "./V8ray/vim-plugin-package" ]; then
        plugin_config
    else
        echo "error: Download failed! Please check your network or try again."
        exit 1
    fi
}

install_all() {
    if [ -d "./V8ray" ]; then
        install_plugin
        install_nerdtree
        install_clangd
    else
        echo "error: Download failed! Please check your network or try again."
        exit 1
    fi
}

show_help() {
    echo "usage: $0 [ --help | -c | -n | -p ]"
    echo '  -a, --all, Install Clangd, NerdTree and Plugin '
    echo '  -c, --clangd, Install Clangd '
    echo '  -n, --nerdtree, Install NerdTree '
    echo '  -p, --plugin, Install Plugin '
    exit 0
}

main() {
    download_git
    vim_config
    echo "Please use the correct parameters!"
    use_parameters "$@"
    [[ "$HELP" -eq '1' ]] && show_help
    [[ "$ALL" -eq '1' ]] && install_all
    [[ "$CLANGD" -eq '1' ]] && install_clangd
    [[ "$NERDTREE" -eq '1' ]] && install_nerdtree
    [[ "$PLUGIN" -eq '1' ]] && install_plugin
}

main "$@"