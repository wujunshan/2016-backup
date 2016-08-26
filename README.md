
# Rails 项目初始化

**使用 [RubyGems 镜像 - 淘宝网](https://ruby.taobao.org/)**

	gem sources --add https://ruby.taobao.org/ --remove https://rubygems.org/
	bundle config mirror.https://rubygems.org https://ruby.taobao.org
	gem install rails -N
	gem install foreman
	


**新建项目**

	rails new demo -T -d postgresql
	rails db:create
	rails db:migrate
	git init
	git add . 
	git commit -m "Initial Commit from $(rails -v)"
	
	
**使用模板**

	rails app:template LOCATION=
	
	