source ~/.zsh/.zprofile/default.zsh

for i in ~/.zsh/.zprofile/*.zsh; do
  [ $i = ~/.zsh/.zprofile/default.zsh ] && continue
  source $i
done
