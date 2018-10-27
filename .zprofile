export LC_ALL=a_JP.UTF-8
export PATH="$PATH:/Users/kat/Library/Android/sdk/platform-tools"

## load other .zprofile files
#
for i in ~/.zsh/zprofile.d/*.zsh; do
  source $i
done
