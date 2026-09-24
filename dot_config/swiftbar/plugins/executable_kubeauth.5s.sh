#!/bin/bash
# <xbar.title>Kube Auth</xbar.title>
# <xbar.desc>Show/toggle kubectl OIDC login state</xbar.desc>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideLastUpdated>true</swiftbar.hideLastUpdated>
# <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>
# <swiftbar.hideSwiftBar>true</swiftbar.hideSwiftBar>
# green = logged in, red = logged out. Click toggles.
export PATH=/opt/homebrew/bin:$HOME/bin:/usr/bin:/bin:/usr/sbin:/sbin

# ponytail: single-path KUBECONFIG only, no colon-separated lists.
KUBE="${KUBECONFIG:-$HOME/.kube/config}"
TTL=${KUBEAUTH_TTL:-900}
# Absolute path on purpose: /opt/homebrew/bin/kubectl-login shadows this one in
# PATH and does not support a piped PIN.
LOGIN_BIN="$HOME/bin/kubectl-login"

# Users with an auth-provider are the ones `kubectl login` created.
# Cert-based users (kind, etc.) are untouched - logout cannot restore them.
oidc_users() {
    kubectl config view -o jsonpath='{range .users[*]}{.name}{"|"}{.user.auth-provider.config.client-id}{"\n"}{end}' 2>/dev/null |
        awk -F'|' '$2 != "" { print $1 }'
}

screen_locked() {
    ioreg -n Root -d1 -a | grep -A1 CGSSessionScreenIsLocked | grep -q '<true/>'
}

notify() { osascript -e "display notification \"$1\" with title \"Kubernetes\"" >/dev/null 2>&1; }

# Modal error. The message is passed as an argument rather than interpolated into
# the script, so tool output cannot break or inject AppleScript.
alert() {
    osascript - "$1" >/dev/null 2>&1 <<'APPLESCRIPT'
on run argv
    display alert "Kubernetes login failed" message (item 1 of argv) as critical buttons {"OK"} default button "OK"
end run
APPLESCRIPT
}

# mtime of the kubeconfig is a free proxy for last activity: kubectl rewrites it
# on token refresh, so an untouched config means an idle session.
stale() {
    [ -f "$KUBE" ] || return 1
    [ $(($(date +%s) - $(stat -f %m "$KUBE"))) -ge "$TTL" ]
}

do_logout() {
    local users
    users=$(oidc_users)
    [ -n "$users" ] || return 0
    kubectl logout $users >/dev/null 2>&1 && notify "$1"
}

case "$1" in
logout)
    do_logout "Logged out"
    exit 0
    ;;
login)
    pin=$(osascript \
        -e 'display dialog "YubiKey PIV PIN" with title "Kubeconfig" default answer "" with hidden answer buttons {"Cancel", "Login"} default button "Login"' \
        -e 'text returned of result' 2>/dev/null) || exit 0
    [ -n "$pin" ] || exit 0

    # The PIN is verified before the key is asked to sign, so a wrong PIN fails
    # fast and no touch is ever needed. Only prompt for a touch if the login is
    # still running after the PIN would have been rejected.
    out_file=$(mktemp)
    printf '%s' "$pin" | "$LOGIN_BIN" --login-methods=yubikey >"$out_file" 2>&1 &
    pid=$!
    (sleep 2 && kill -0 "$pid" 2>/dev/null && notify "Touch your YubiKey") &

    if wait "$pid"; then
        notify "Logged in"
    else
        alert "$(cat "$out_file")"
    fi

    rm -f "$out_file"
    exit 0
    ;;
esac

if [ ! -f "$KUBE" ]; then
    echo ":questionmark.circle: | sfcolor=gray"
    echo "---"
    echo "No kubeconfig at $KUBE"
    exit 0
fi

users=$(oidc_users)
if [ -n "$users" ]; then
    if screen_locked; then
        do_logout "Logged out: screen locked"
        users=""
    elif stale; then
        do_logout "Logged out: idle for $((TTL / 60)) min"
        users=""
    fi
fi

if [ -n "$users" ]; then
    echo ":lock.open.fill: | sfcolor=green bash='$0' param1=logout terminal=false refresh=true"
else
    echo ":lock.fill: | sfcolor=red bash='$0' param1=login terminal=false refresh=true"
fi
