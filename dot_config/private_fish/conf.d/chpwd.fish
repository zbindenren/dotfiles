function chpwd --on-variable PWD --description 'handler of changing $PWD'
  if not status --is-command-substitution ; and status --is-interactive
    if test -d $PWD/.git
      onefetch
    end
  end
end
