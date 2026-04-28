ZSHENV_DIR="$HOME/.zsh/.zshenv"
ZSHENV_DEFAULT="$ZSHENV_DIR/default.zsh"

[ -r "$ZSHENV_DEFAULT" ] && source "$ZSHENV_DEFAULT"

for file in "$ZSHENV_DIR"/*.zsh(N); do
  [ "$file" = "$ZSHENV_DEFAULT" ] && continue
  [ -r "$file" ] && source "$file"
done

unset ZSHENV_DIR ZSHENV_DEFAULT file

