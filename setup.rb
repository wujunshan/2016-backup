def source_paths
  [File.expand_path('../templates', __FILE__)]
end

component = File.expand_path("../lib", __FILE__)

copy_file 'CHANGELOG.md'
remove_file 'README.md'
copy_file 'README.md'

after_bundle do
  run "spring binstub --remove --all"
  rails_command "db:create"
  rails_command "db:migrate"
  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }
  rails_command "app:template LOCATION=#{component}/common.rb"
  run "bundle exec spring binstub  --all"
  git add: '.'
  git commit: %Q{ -m 'Setup Spring' }
end
