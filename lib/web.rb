
gem 'semantic-ui-sass', '~> 2.2'
gem 'slim-rails', '~> 3.1'

gem_group :development do
  gem 'guard-livereload', '~> 2.5'
  gem 'rack-livereload', '~> 0.3.16'

  gem 'meta_request', '~> 0.4.0'
end

run_bundle

environment 'config.assets.quiet = true', env: 'development'

# Semantic UI for Sass
copy_file 'app/assets/stylesheets/application.css',
  'app/assets/stylesheets/application.scss' do |content|
    content << '@import "semantic-ui";'
end
remove_file 'app/assets/stylesheets/application.css'
insert_into_file 'app/assets/javascripts/application.js', :after => "jquery\n" do
  "//= require semantic-ui\n"
end



# Quiet Assets
gem_group :development do
  gem 'quiet_assets'
end
run_bundle
git add: '.'
git commit: %Q< -m 'add quiet_assets' >


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

git add: '.'
git commit: %Q< -m 'add root page' >


# Guard
run "guard init livereload"
environment nil , env: 'development' do
  %q{config.middleware.insert_after ActionDispatch::Static, Rack::LiveReload}
end
