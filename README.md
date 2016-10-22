[rails-application-templates-real-world](https://www.sitepoint.com/rails-application-templates-real-world/)


	def source_paths
	  Array(super) + 
	    [File.expand_path(File.dirname(__FILE__))]
	end
	
	
	
[源码](https://github.com/rails/rails/tree/bee9434cdf4f56dc51027a8890cf04f506544735/railties/lib/rails)	