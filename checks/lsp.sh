# lsp: language servers Helix uses (vtsls is set in helix/languages.toml).
tool pylsp                       /opt/homebrew/bin/pylsp                       'brew install python-lsp-server'
tool vtsls                       /opt/homebrew/bin/vtsls                       'brew install vtsls'
# for Claude Code's typescript-lsp plugin; works in projects with typescript in node_modules
tool typescript-language-server  /opt/homebrew/bin/typescript-language-server  'brew install typescript-language-server'
tool lua-language-server         /opt/homebrew/bin/lua-language-server         'brew install lua-language-server'
tool taplo                       /opt/homebrew/bin/taplo                       'brew install taplo'
tool vscode-json-language-server /opt/homebrew/bin/vscode-json-language-server 'brew install vscode-langservers-extracted'
