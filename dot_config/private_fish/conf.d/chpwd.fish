function chpwd --on-variable PWD --description 'handler of changing $PWD'
  if not status --is-command-substitution ; and status --is-interactive
    if test -d $PWD/.git; and type -q onefetch
      onefetch 2> /dev/null
    end
  end
end
