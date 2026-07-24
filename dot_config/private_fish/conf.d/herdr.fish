function herdr-ws-fzf --description 'Fuzzy switch Herdr workspaces from inside a session'
    # Requires: herdr, jq, fzf
    set json (herdr workspace list 2>/dev/null)
    or begin
        echo "Failed to reach Herdr server." >&2
        return 1
    end

    # Get current workspace label for preselection
    set current_label (printf '%s' "$json" | jq -r --arg id "$HERDR_WORKSPACE_ID" \
        '.result.workspaces[] | select(.workspace_id == $id) | .label' 2>/dev/null)

    # Build lines: "id<TAB>label"
    set selection (printf '%s' "$json" \
        | jq -r '.result.workspaces[] | [.workspace_id, .label] | @tsv' \
        | fzf \
            --query="$current_label" \
            --header="Herdr workspaces — Enter to focus, Esc to cancel" \
            --delimiter='\t' \
            --with-nth=2 \
            --exact \
            --cycle \
            --height=40% \
            --reverse \
            --border)

    test -n "$selection"; or return 0

    # First field (before tab) is the workspace ID
    set ws_id (echo "$selection" | cut -f1)
    herdr workspace focus $ws_id
end

function hma
    # Refuse to run from inside herdr (like tma checks $TMUX)
    if test "$HERDR_ENV" = 1
        echo "Error: cannot attach from within herdr session" >&2
        return 1
    end

    # Check if herdr server is running
    if not herdr api snapshot >/dev/null 2>&1
        echo "Error: herdr server is not running" >&2
        return 1
    end

    # List workspaces, build "label\tworkspace_id" lines for fzf
    set lines (herdr workspace list 2>/dev/null | \
        python3 -c "import json,sys
for ws in json.load(sys.stdin)['result']['workspaces']:
    print(f\"{ws['label']}\\t{ws['workspace_id']}\")" 2>/dev/null)
    if test -z "$lines"
        echo "No herdr workspaces found" >&2
        return 1
    end

    # Pick a workspace with fzf, extract the workspace_id (after the tab)
    set selection (printf '%s\n' $lines | fzf --no-multi --delimiter='\t' --with-nth=1 | string match -r '\t([^\t]+)$' | tail -1)
    if test -n "$selection"
        herdr workspace focus $selection >/dev/null
        herdr
    end
end

function hmn
    # Refuse to run from inside herdr (like tmn checks $TMUX)
    if test "$HERDR_ENV" = 1
        echo "Error: cannot create workspace from within herdr session" >&2
        return 1
    end

    # Check if herdr server is running
    if not herdr api snapshot >/dev/null 2>&1
        echo "Error: herdr server is not running" >&2
        return 1
    end

    set name (basename $PWD)
    if test -n "$argv[1]"
        set name "$argv[1]"
    end

    # Create workspace (detached, like tmux new-session -d)
    set ws_output (herdr workspace create --label $name --cwd (pwd) --no-focus 2>&1)
    if test $status -ne 0
        echo "Error: failed to create workspace" >&2
        return 1
    end

    # Extract IDs from JSON output (never construct IDs — parse them)
    set ws_id (echo $ws_output | string match -r '"workspace_id":"([^"]+)"' | tail -1)
    set tab1_id (echo $ws_output | string match -r '"tab_id":"([^"]+)"' | tail -1)
    set pane_id (echo $ws_output | string match -r '"pane_id":"([^"]+)"' | tail -1)

    # Rename first tab to neovim and launch nvim (pane run = text + Enter)
    herdr tab rename $tab1_id neovim >/dev/null
    herdr pane run $pane_id nvim >/dev/null

    # Create pi tab (second tab) and launch the pi agent
    set pi_output (herdr tab create --workspace $ws_id --label "pi" --cwd (pwd) --no-focus 2>&1)
    set pi_pane_id (echo $pi_output | string match -r '"pane_id":"([^"]+)"' | tail -1)
    herdr pane run $pi_pane_id pi >/dev/null

    # Create remaining term tabs
    for i in (seq 2 4)
        herdr tab create --workspace $ws_id --label "term0$i" --cwd (pwd) --no-focus >/dev/null 2>&1
    end

    # Attach: focus the workspace and its neovim tab, then attach the client
    herdr workspace focus $ws_id >/dev/null
    herdr tab focus $tab1_id >/dev/null
    herdr
end

function hssh --description 'SSH into multiple hosts in a Herdr workspace'
    # Check if herdr server is running
    if not herdr api snapshot >/dev/null 2>&1
        echo "Error: herdr server is not running" >&2
        return 1
    end

    if not test -f $HOME/.all.sys
        echo "Error: $HOME/.all.sys not found, run tssh_clone first" >&2
        return 1
    end

    # Max panes per tab, default 6
    set -l max_panes 6
    if set -q argv[1]
        set max_panes $argv[1]
    end

    # Select hosts via fzf
    set -l hosts (command cat $HOME/.all.sys | fzf --multi --prompt="Select hosts> ")
    if test (count $hosts) -eq 0
        return 0
    end

    # Find existing ssh workspace or create a new one
    set -l existing_ws (herdr workspace list 2>/dev/null | python3 -c "
import json,sys
data = json.load(sys.stdin)
for ws in data['result']['workspaces']:
    if ws['label'] == 'ssh':
        print(ws['workspace_id'])
" 2>/dev/null)

    if test -n "$existing_ws"
        # Add a new tab to existing workspace
        set tab_output (herdr tab create --workspace $existing_ws --label "ssh" --cwd $HOME --no-focus 2>&1)
        if test $status -ne 0
            echo "Error: failed to create tab in existing ssh workspace" >&2
            return 1
        end
        set ws_id $existing_ws
        set tab_id (echo $tab_output | string match -r '"tab_id":"([^"]+)"' | tail -1)
        set current_pane (echo $tab_output | string match -r '"pane_id":"([^"]+)"' | tail -1)
        set tab_count (herdr tab list --workspace $existing_ws 2>/dev/null | python3 -c "
import json,sys
data = json.load(sys.stdin)
print(len(data['result']['tabs']))
" 2>/dev/null)
    else
        # Create workspace (detached)
        set ws_output (herdr workspace create --label ssh --cwd $HOME --no-focus 2>&1)
        if test $status -ne 0
            echo "Error: failed to create workspace" >&2
            return 1
        end
        set ws_id (echo $ws_output | string match -r '"workspace_id":"([^"]+)"' | tail -1)
        set tab_id (echo $ws_output | string match -r '"tab_id":"([^"]+)"' | tail -1)
        set current_pane (echo $ws_output | string match -r '"pane_id":"([^"]+)"' | tail -1)
        set tab_count 1
    end

    herdr tab rename $tab_id "ssh-$tab_count" >/dev/null
    set pane_count 1
    set host_idx 1
    set -l total (count $hosts)

    # First host in the initial pane
    herdr pane run $current_pane "ssh -t $JUMP_HOST ssh $hosts[$host_idx]" >/dev/null
    set host_idx (math "$host_idx + 1")

    # Remaining hosts: equal-width columns, new tab when max_panes reached
    while test $host_idx -le $total
        if test $pane_count -ge $max_panes
            set tab_count (math $tab_count + 1)
            set tab_output (herdr tab create --workspace $ws_id --label "ssh-$tab_count" --cwd $HOME --no-focus 2>&1)
            set tab_id (echo $tab_output | string match -r '"tab_id":"([^"]+)"' | tail -1)
            set current_pane (echo $tab_output | string match -r '"pane_id":"([^"]+)"' | tail -1)
            set pane_count 1
        else
            # Equal-width columns: ratio = 1/(panes_left_including_current)
            set -l remaining_hosts (math "$total - $host_idx + 1")
            set -l panes_in_tab $remaining_hosts
            if test $panes_in_tab -gt $max_panes
                set panes_in_tab $max_panes
            end
            set -l ratio (math "1 / ($panes_in_tab - $pane_count + 1)")
            set split_output (herdr pane split $current_pane --direction right --ratio $ratio --no-focus 2>&1)
            set current_pane (echo $split_output | string match -r '"pane_id":"([^"]+)"' | tail -1)
            set pane_count (math "$pane_count + 1")
        end

        herdr pane run $current_pane "ssh -t $JUMP_HOST ssh $hosts[$host_idx]" >/dev/null
        set host_idx (math "$host_idx + 1")
    end

    # Focus and attach (only attach when outside herdr)
    herdr workspace focus $ws_id >/dev/null
    herdr tab focus $tab_id >/dev/null
    if test "$HERDR_ENV" != 1
        herdr
    end
end
