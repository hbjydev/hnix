# Used in system/shared/home-manager.nix

eval "$(k9s completion zsh)"

ctlc () {
  cat <<EOF | ctlptl apply -f -
apiVersion: ctlptl.dev/v1alpha1
kind: Cluster
product: kind
registry: ctlptl-registry
kindV1Alpha4Cluster:
  name: kind
  nodes:
  - role: control-plane
    kubeadmConfigPatches:
      - |
        kind: InitConfiguration
        nodeRegistration:
          kubeletExtraArgs:
            node-labels: "ingress-ready=true"
    extraPortMappings:
      - containerPort: 80
        hostPort: 8282
        protocol: TCP
      - containerPort: 443
        hostPort: 8383
        protocol: TCP
EOF
}

kindc () {
  cat <<EOF | kind create cluster --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 8282
    protocol: TCP
  - containerPort: 443
    hostPort: 8443
    protocol: TCP
EOF
}

license () {
  curl -L "api.github.com/licenses/$1" | jq -r .body > LICENSE
}

n () {
  if [ -n $NNNLVL ] && [ "$NNNLVL" -ge 1 ]; then
    echo "nnn is already running"
    return
  fi

  export NNN_TMPFILE="$HOME/.config/nnn/.lastd"

  nnn -adeHo "$@"

  if [ -f "$NNN_TMPFILE" ]; then
    . "$NNN_TMPFILE"
    rm -f "$NNN_TMPFILE" > /dev/null
  fi
}

newt () {
  has_existing="$(git branch -v | grep -e " ${1} ")"

  git_flags=""

  if [[ "$has_existing" == "" ]]; then
    git_flags="-b"
  fi

  git worktree add "${git_flags}" "${1}" "${1}"
}

if [[ -d "$HOME/.pyenv" ]]; then
  export PYENV_ROOT="$HOME/.pyenv"
  command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi

if [[ -d "/opt/homebrew" ]]; then
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
fi

# Get weather data on startup
curl 'wttr.in/sheffield?0Q'
