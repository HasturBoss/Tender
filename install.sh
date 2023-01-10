#!/usr/bin/env bash

# Change 'DOWNLOAD_LINK' for you
DOWNLOAD_LINK="https://github.com/HasturBoss/Tender.git"

# Chang 'var_0,1,2,...,n'
# Edit <localhost> and <port>

# author:HasturBoss
download_git() {
    if [ -d "./Tender/" ]; then
        echo "The file has been downloaded!"
    else
        git clone "$DOWNLOAD_LINK"
        echo "The file has been downloaded!"
    fi
}

vimrc_config() {
    if [ -f "./Tender/vimrc.txt" ]; then
        # Do not modify
        tr -d "\015" <./Tender/vimrc.txt> ./Tender/vimrc_bak.txt
        sed -i "s/<username>/$current_username/g" ./Tender/vimrc_bak.txt
        cp -f ./Tender/vimrc_bak.txt /usr/share/vim/vimrc
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
                ln -s /usr/share/vim/vimrc /home/$current_username/.vim/.vimrc
            else
                vimrc_config
                ln -s /usr/share/vim/vimrc /home/$current_username/.vim/.vimrc
            fi
        else
            mkdir /home/$current_username/.vim \
            /home/$current_username/.vim/plugin \
            /home/$current_username/.vim/plugin/ycm
            vimrc_config
            ln -s /usr/share/vim/vimrc /home/$current_username/.vim/.vimrc
        fi
    else
        echo "Username does not exist!"
        exit 1
    fi
}

ycm_extra_conf() {
    if [ -f "./Tender/ycm_extra_conf.txt" ]; then
        local var=1
        for var in $(seq 1 23)
        do
            if [ -d "/usr/lib/gcc/x86_64-linux-gnu/$var" -a "/usr/include/c++/$var" ]; then
                tr -d "\015" <./Tender/ycm_extra_conf.txt> ./Tender/ycm_extra_conf_bak.txt
                sed -i "s/9/$var/g" ./Tender/ycm_extra_conf_bak.txt
                cat ./Tender/ycm_extra_conf_bak.txt > /home/$current_username/.vim/plugin/ycm/third_party/ycmd/examples/.ycm_extra_conf.py
                echo "The .ycm_extra_conf.py is edited!"
            else
                continue
            fi
        done
    else
        echo "error: Download failed! Please check your network or try again."
        exit 1
    fi
}

clangd_config() {
    echo -e "\033[31m<Must be executed with root privileges>\033[0m"
    echo 'Please confirm the version, vim-plug,CMake(at least 3.13), Vim(at least 8.1.2269) and Python(at least 3.6)'
    read -p "Please input y or n, Y or N: " char
    if [ $char = "y" -o $char = "Y" ]; then
        if [ -f "./Tender/vim-language-server/third_party/ycmd/build.py" ]; then
            echo -e "\033[31mEdit ./Tender/vim-language-server/install.sh\033[0m"
            echo -e "  \033[31m<0. (127.0.0.1:10809)>\n\033[0m" \
            " \033[31m<1. (10.0.2.2:10809)>\n\033[0m"
            read -p "Please select local ip and port(0 or 1): " key
            case "$key" in
                '0')
                    var_0='127.0.0.1'
                    sed -i "s/<localhost>/$var_0/g" ./Tender/vim-language-server/third_party/ycmd/build.py
                    var_1='10809'
                    sed -i "s/<port>/$var_1/g" ./Tender/vim-language-server/third_party/ycmd/build.py
                    echo "The python file change successfully!"
                    ;;
                '1')
                    var_2='10.0.2.2'
                    sed -i "s/<localhost>/$var_2/g" ./Tender/vim-language-server/third_party/ycmd/build.py
                    var_3='10809'
                    sed -i "s/<port>/$var_3/g" ./Tender/vim-language-server/third_party/ycmd/build.py
                    echo "The python file change successfully!"
                    ;;
                *)
                    echo "The invalid symbol!"
                    ;;
            esac
        else
            echo "error: Download failed! Please check your network or try again."
            exit 1
        fi
        apt install build-essential cmake clangd python3-dev vim-nox
        (
        python3 ./Tender/vim-language-server/install.py --clangd-completer --cs-completer --verbose
        )
        cp -rf ./Tender/vim-language-server/* /home/$current_username/.vim/plugin/ycm
        echo -e "\033[31mEdit /home/<username>/.vim/plugin/ycm/third_party/ycmd/examples/.ycm_extra_conf.py\033[0m"
        ycm_extra_conf
    elif [ $char = "n" -o $char = "N" ]; then
        return 1
    else
        echo "The invalid symbol!"
        return 1
    fi
}

botinline_config() {
    echo "Please confirm the Vim is installed!"
    read -p "Please input y or n, Y or N: " char
    if [ $char = "y" -o $char = "Y" ]; then
        cp -rf ./Tender/vim-plugin-botinline/ /home/$current_username/.vim/plugin/botinline
        echo -e "\033[31mBottom has been installed!\033[0m"
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
        cp -rf ./Tender/vim-plugin-nerdtree/ /home/$current_username/.vim/plugin/nerdtree
        echo -e "\033[31mNerdTree has been installed!\033[0m"
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
        local var=1
        for var in $(seq 81 99)
        do 
            if [ -d "/usr/share/vim/vim$var" ]; then
                cp -f ./Tender/vim-plugin-package/plug.vim /usr/share/vim/vim$var/autoload/plug.vim
                echo -e "\033[31mPlugin has been installed!\033[0m"
            else
                continue
            fi
        done
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
            '-b' | '--botinline')
                BOTTOM='1'
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
    if [ -d "./Tender/vim-language-server" ]; then
        clangd_config
    else
        echo "error: Download failed! Please check your network or try again."
        exit 1
    fi
}

install_bottom() {
    if [ -d "./Tender/vim-plugin-botinline" ]; then
        botinline_config
    else
        echo "error: Download failed! Please check your network or try again."
        exit 1
    fi
}

install_nerdtree() {
    if [ -d "./Tender/vim-plugin-nerdtree" ]; then
        nerdtree_config
    else
        echo "error: Download failed! Please check your network or try again."
        exit 1
    fi
}

install_plugin() {
    if [ -d "./Tender/vim-plugin-package" ]; then
        plugin_config
    else
        echo "error: Download failed! Please check your network or try again."
        exit 1
    fi
}

install_all() {
    if [ -d "./Tender" ]; then
        install_plugin
        install_nerdtree
        install_bottom
        install_clangd
    else
        echo "error: Download failed! Please check your network or try again."
        exit 1
    fi
}

show_help() {
    echo "usage: $0 [ --help | -c | -n | -p ]"
    echo '  -a, --all, Install Clangd, NerdTree and Plugin '
    echo '  -b, --botinline, Install Bottom '
    echo '  -c, --clangd, Install Clangd '
    echo '  -n, --nerdtree, Install NerdTree '
    echo '  -p, --plugin, Install Plugin '
    exit 0
}

main() {
    detection_agent
    download_git
    echo -e "\033[31mPlease confirm whether to modify .vimrc file!\033[0m"
    read -p "Please input y or n, Y or N: " vim
    if [ $vim = "y" -o $vim = "Y" ]; then
        vim_config
    elif [ $vim = "n" -o $vim = "N" ]; then
        echo "Continue..."
    else
        echo "The invalid symbol!"
        return 1
    fi
    echo "Please use the correct parameters!"
    use_parameters "$@"
    [[ "$HELP" -eq '1' ]] && show_help
    [[ "$ALL" -eq '1' ]] && install_all
    [[ "$BOTTOM" -eq '1' ]] && install_bottom
    [[ "$CLANGD" -eq '1' ]] && install_clangd
    [[ "$NERDTREE" -eq '1' ]] && install_nerdtree
    [[ "$PLUGIN" -eq '1' ]] && install_plugin
    echo -e "\033[33mThe program was successfully installed!\033[0m"
}

main "$@"
