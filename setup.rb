require 'active_support/all'

def source_paths
  [File.expand_path('../templates', __FILE__)]
end

after_bundle do
  rails_command "db:create"
  rails_command "db:migrate"
  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }
  apply  File.expand_path("../lib/common.rb", __FILE__)
  # apply  File.expand_path("../lib/web.rb", __FILE__)
  apply  File.expand_path("../lib/api.rb", __FILE__)
end
