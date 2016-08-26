run_bundle
run "spring binstub --remove --all"

run "bundle exec spring binstub  --all"
git add: '.'
git commit: %Q< -m 'oh-my-rails: api' >
