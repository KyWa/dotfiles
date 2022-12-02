if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi
eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH="/opt/homebrew/opt/openssl@3/bin:$PATH"
export PATH="/opt/homebrew/opt/libxml2/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
