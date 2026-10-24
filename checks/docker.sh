# docker: colima + docker CLI tooling, macOS only.
[[ "$OSTYPE" == darwin* ]] || return 0
tool colima         /opt/homebrew/bin/colima         'brew install colima'
tool docker         /opt/homebrew/bin/docker         'brew install docker'
tool docker-compose /opt/homebrew/bin/docker-compose 'brew install docker-compose'
tool docker-buildx  /opt/homebrew/bin/docker-buildx  'brew install docker-buildx'
