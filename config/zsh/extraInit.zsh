# Used in system/shared/home-manager.nix

eval "$(k9s completion zsh)"

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
    hostPort: 8080
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

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

if [[ -d "/opt/homebrew" ]]; then
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
fi
