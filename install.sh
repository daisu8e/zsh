#!/bin/sh

cd `dirname $0`

ln -s ${PWD}/.zlogin ${HOME}/.zlogin
ln -s ${PWD}/.zlogout ${HOME}/.zlogout
ln -s ${PWD}/.zprofile ${HOME}/.zprofile
ln -s ${PWD}/.zshenv ${HOME}/.zshenv
ln -s ${PWD}/.zshrc ${HOME}/.zshrc
ln -s ${PWD}/.zsh ${HOME}/.zsh
