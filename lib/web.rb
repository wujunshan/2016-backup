# gems
gem 'semantic-ui-sass', '~> 2.2'
gem 'slim-rails', '~> 3.1'
gem 'local_time', '~> 1.0'

gem_group :development do
  gem 'guard-livereload', '~> 2.5'
  gem 'rack-livereload', '~> 0.3.16'

  gem 'meta_request', '~> 0.4.0'

  gem 'better_errors', '~> 2.1'
end

run_bundle
run "bundle exec spring stop"
run "bundle exec spring binstub --remove --all"

environment 'config.assets.quiet = true', env: 'development'

# I18n
directory 'locales/views', 'config/locales/views'

# Semantic UI for Sass
# copy_file 'app/assets/stylesheets/application.css',
#   'app/assets/stylesheets/application.scss' do |content|
#     content << '@import "semantic-ui";'
# end
# remove_file 'app/assets/stylesheets/application.css'
insert_into_file 'app/assets/javascripts/application.js', :after => "jquery\n" do
  "//= require semantic-ui\n"
end

# welcome
application "config.generators.assets = false"
application "config.generators.helper = false"
generate(:controller, 'welcome', 'index', '--skip-routes')
generate(:controller, 'admin/welcome', 'index', '--skip-routes')
route("root 'welcome#index'")
route("
namespace :admin do
  root 'welcome#index'
end
")



# Guard
run "bundle exec guard init livereload"
environment nil , env: 'development' do
  %q{config.middleware.insert_after ActionDispatch::Static, Rack::LiveReload}
end

run "bundle exec spring binstub  --all"
git add: '.'
git commit: %Q< -m 'oh-my-rails: web' >
