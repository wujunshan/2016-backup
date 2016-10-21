# support docker

copy_file 'Dockfile'
copy_file 'docker-compose.yml'

git add: '.'
git commit: %Q< -m 'oh-my-rails: Docker' >
puts "Now Docker Initlize"
