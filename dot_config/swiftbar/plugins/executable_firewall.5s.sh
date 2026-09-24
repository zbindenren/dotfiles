#!/bin/bash
# <xbar.title>Firewall</xbar.title>
# <xbar.desc>Show/toggle the pnet firewall connect tab in Chrome</xbar.desc>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideLastUpdated>true</swiftbar.hideLastUpdated>
# <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>
# <swiftbar.hideSwiftBar>true</swiftbar.hideSwiftBar>
# green = tab open (firewall session alive), red = no tab. Click toggles.
export PATH=/opt/homebrew/bin:$HOME/bin:/usr/bin:/bin:/usr/sbin:/sbin

URL="https://fwpfadmin.pnet.ch/connect/PortalMain"
# The portal redirects through SSO, so match the host, not the full URL.
MATCH="fwpfadmin.pnet.ch"
TTL=${FIREWALL_TTL:-3600}
# Stamped when the tab is opened; its age is how long the tab has been up.
STAMP="${TMPDIR:-/tmp}/swiftbar-firewall.stamp"

screen_locked() {
    ioreg -n Root -d1 -a | grep -A1 CGSSessionScreenIsLocked | grep -q '<true/>'
}

expired() {
    [ -f "$STAMP" ] || return 1
    [ $(($(date +%s) - $(stat -f %m "$STAMP"))) -ge "$TTL" ]
}

notify() { osascript -e "display notification \"$1\" with title \"Firewall\"" >/dev/null 2>&1; }

# Prints "yes" if a Chrome tab on MATCH exists. With "close" it first clicks the
# portal's Log Out button (ending the session server-side), then closes the tab.
# The click needs Chrome > View > Developer > "Allow JavaScript from Apple Events";
# without it the JS silently fails and only the tab is closed.
tab() {
    osascript - "$URL" "$MATCH" "$1" <<'APPLESCRIPT'
on run argv
  set theURL to item 1 of argv
  set theMatch to item 2 of argv
  set theAction to item 3 of argv
  set logoffJS to "window.onbeforeunload=null; var b=document.getElementById('UserCheck_Logoff_Button'); if (b) { b.click(); 'clicked' } else if (window.oNACAccess) { oNACAccess.relogin(); 'relogin' } else { 'none' }"
  if application "Google Chrome" is running then
    tell application "Google Chrome"
      repeat with w in windows
        repeat with t in tabs of w
          if URL of t contains theMatch then
            if theAction is "close" then
              try
                execute t javascript logoffJS
                delay 2
              end try
              close t
            end if
            return "yes"
          end if
        end repeat
      end repeat
    end tell
  end if
  if theAction is "open" then
    tell application "Google Chrome"
      activate
      open location theURL
    end tell
  end if
  return "no"
end run
APPLESCRIPT
}

if [ "$1" = toggle ]; then
    # "close" closes an existing tab; if none exists it opens one.
    if [ "$(tab close)" = yes ]; then
        rm -f "$STAMP"
    else
        tab open >/dev/null
        touch "$STAMP"
    fi
    exit 0
fi

open=$(tab check)

# The close path clicks Log Out first, so this really does end the session.
if [ "$open" = yes ]; then
    # A tab opened outside the plugin has no stamp; start its clock now.
    [ -f "$STAMP" ] || touch "$STAMP"

    if screen_locked; then
        tab close >/dev/null
        rm -f "$STAMP"
        notify "Logged out: screen locked"
        open=no
    elif expired; then
        tab close >/dev/null
        rm -f "$STAMP"
        notify "Logged out: connected for $((TTL / 60)) min"
        open=no
    fi
fi

if [ "$open" = yes ]; then
    echo ":shield.fill: | sfcolor=green bash='$0' param1=toggle terminal=false refresh=true"
else
    echo ":shield.slash: | sfcolor=red bash='$0' param1=toggle terminal=false refresh=true"
fi
