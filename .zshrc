source ~/.zsh/.zshrc/default.zsh

for i in ~/.zsh/.zshrc/*.zsh; do
  [ $i = ~/.zsh/.zshrc/default.zsh ] && continue
  source $i
done
