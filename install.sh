#!/bin/bash

# Функция для проверки и установки пакетов
install_package() {
  if ! command -v "$1" &> /dev/null; then
    echo "Установка $1..."
    sudo apt-get install -y "$1"
  else
    echo "$1 уже установлен."
  fi
}

# Установка необходимых пакетов
install_package git
install_package curl
install_package neovim

# Клонирование репозитория dotfiles
if [ ! -d ~/dotfiles ]; then
  echo "Клонирование репозитория dotfiles..."
  git clone https://github.com/Ildarc4S/Neovim-dots.git ~/dotfiles
else
  echo "Репозиторий dotfiles уже существует."
fi

# Создание символических ссылок
if [ ! -d ~/.config/nvim ]; then
  echo "Создание символических ссылок..."
  mkdir -p ~/.config
  ln -sf ~/dotfiles/nvim ~/.config/nvim
else
  echo "Конфигурация Neovim уже существует."
fi

# Установка lazy.nvim (если не установлен)
LAZY_PATH=~/.local/share/nvim/lazy/lazy.nvim
if [ ! -d "$LAZY_PATH" ]; then
  echo "Установка lazy.nvim..."
  git clone --filter=blob:none https://github.com/folke/lazy.nvim.git "$LAZY_PATH"
else
  echo "lazy.nvim уже установлен."
fi

# Синхронизация плагинов через lazy.nvim
if command -v nvim &> /dev/null; then
  echo "Синхронизация плагинов..."
  nvim --headless "+Lazy! sync" +qa
else
  echo "Neovim не установлен. Установите Neovim и повторите попытку."
  exit 1
fi

echo "Установка завершена!"
