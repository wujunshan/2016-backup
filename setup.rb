component = File.expand_path("../lib", __FILE__)

after_bundle do
  rails_command "db:create"
  rails_command "db:migrate"
  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }

  rails_command "app:template LOCATION=#{component}/common.rb"
end
