function kx --description 'Select a kubernetes context and open k9s'
    set current (kubectl config current-context 2>/dev/null)
    set context (begin
        echo "* $current"
        kubectl config get-contexts -o name | grep -v "^$current\$"
    end | fzf --prompt='k8s context> ')
    set context (string replace -r '^\* ' '' $context)
    if test -n "$context"
        k9s --context $context --command namespaces
    end
end
