
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# ~/.zsh/environment.zsh

# --------------
# PATH
# --------------

# Ensures user-installed binaries take precedence over system binaries
export PATH=/usr/local/bin:$PATH 

# Python and Python packages
export PATH="$PATH:/usr/local/bin/python3" # replace with your python3 path
export PATH="$PATH:$HOME/Library/Python/3.x/bin" # replace with your pip packages path

# Flutter SDK
export PATH="$PATH:$HOME/opt/homebrew/bin/flutter" # replace with your flutter sdk path

# Dart SDK (usually included with Flutter SDK)
export PATH="$PATH:$HOME/usr/local/opt/flutter/stable/bin/cache/dart-sdk" # replace with your dart sdk path

# --------------
# Flutter Settings
# --------------

# Enable Flutter desktop support
export ENABLE_FLUTTER_DESKTOP="true"

# --------------
# Python Settings
# --------------

# pyenv settings
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# pipenv settings
if [[ "$(command -v pipenv)" ]]; then
  export PIPENV_VENV_IN_PROJECT=1
fi



command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"


# --------------
# zshtools
# --------------

# autojump
[[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh


