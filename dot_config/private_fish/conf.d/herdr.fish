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
