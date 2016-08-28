gem 'active_model_serializers', '~> 0.10.2'

run_bundle
run "spring binstub --remove --all"

# ActiveModelSerializers
create_file 'config/initializers/json_api.rb' do
  <<-EOS.strip_heredoc
    ActiveModel::Serializer.config.adapter = :json_api
    Mime::Type.register "application/json", :json, %w( text/x-json application/jsonrequest application/vnd.api+json )
  EOS
end

run "bundle exec spring binstub  --all"
git add: '.'
git commit: %Q< -m 'oh-my-rails: api' >
