if [ -f ~/.zsh/.zshrc/theme.zsh ]; then
  source ~/.zsh/.zshrc/theme.zsh
fi

source ~/.zsh/.zshrc/default.zsh

for i in ~/.zsh/.zshrc/*.zsh; do
  [ $i = ~/.zsh/.zshrc/default.zsh ] && continue
  [ $i = ~/.zsh/.zshrc/theme.zsh ] && continue
  source $i
done
