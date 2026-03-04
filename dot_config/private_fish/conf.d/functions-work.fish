function tssh_clone
    scp $JUMP_HOST:/etc/pssh/by-os/linux/all.sys $HOME/.all.sys
    and echo "Cloned to $HOME/.all.sys ("(wc -l < $HOME/.all.sys | string trim)" hosts)"
end

function tssh
    if not set -q TMUX
        echo "Error: must be inside a tmux session" >&2
        return 1
    end

    if not test -f $HOME/.all.sys
        echo "Error: $HOME/.all.sys not found, run tssh_clone first" >&2
        return 1
    end

    set -l hosts (command cat $HOME/.all.sys | fzf --multi --prompt="Select hosts> ")

    if test (count $hosts) -eq 0
        return 0
    end

    tmux new-window -n tssh "ssh -t $JUMP_HOST ssh $hosts[1]"

    # remaining hosts each get a split pane
    for host in $hosts[2..]
        tmux split-window -t tssh "ssh -t $JUMP_HOST ssh $host"
        tmux select-layout -t tssh tiled
    end
end

function ssh-add-yubi-key
    if ssh-add -l | grep -q "Key For PIV Authentication"
        return 0
    end
    ssh-add -s /usr/lib/ssh-keychain.dylib
end

function ssh-add-opkssh
    if ssh-add -l | grep -q "openpubkey cert"
        return 0
    end
    set -l OPK (ls $HOME/.ssh/opkssh/*connect)
    test -r "$OPK"; and ssh-add $OPK
end

function reload-keys
    ssh-add -D
    ssh-add-opkssh
    ssh-add-yubi-key
end

function gitlab-keys-update
    if not command -v glab >/dev/null 2>&1
        echo "glab command not found, skipping gitlab-keys-update" >&2
        return 1
    end

    # YubiKey
    for line in (ssh-add -L | grep -i "Key For PIV Authentication")
        if not glab ssh-key list | grep -e yubikey | grep -q (string sub -l 80 $line)
            glab ssh-key list --show-id | grep -e yubikey | grep -v ID | awk -F' ' '{print $1}' | xargs -I'{}' glab ssh-key delete '{}'
            echo $line | glab ssh-key add -t yubikey
        end
    end

    # OPKSSH key / gitlab cannot handle ssh-certificates, so we only upload the ecdsa-sha2-nistp256 public key
    for line in (ssh-add -L | grep -e "openpubkey cert" | grep -e "ecdsa-sha2-nistp256 ")
        if not glab ssh-key list | grep -e opkssh | grep -q (string sub -l 80 $line)
            glab ssh-key list --show-id | grep -e opkssh | grep -v ID | awk -F' ' '{print $1}' | xargs -I'{}' glab ssh-key delete '{}'
            echo $line | glab ssh-key add -t opkssh
        end
    end
end

alias opkssh-login='getkeys2 login; and reload-keys; and gitlab-keys-update'
alias opkssh-logout='getkeys2 logout; and reload-keys'

function proxy_user
    set -l default_port 3128
    echo "Proxy host:"
    read proxy
    echo "Port (default $default_port):"
    read port
    if test -z "$port"
        set port $default_port
    end
    echo "Password:"
    read -s password
    echo
    set -gx http_proxy "http://$USER:$password@$proxy:$port"
    set -gx https_proxy "http://$USER:$password@$proxy:$port"
end
