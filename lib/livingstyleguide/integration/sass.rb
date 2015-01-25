sass_directory = File.join(File.dirname(__FILE__), '..', '..', '..', 'stylesheets')
if ENV.has_key?("SASS_PATH")
  ENV["SASS_PATH"] = ENV["SASS_PATH"] + File::PATH_SEPARATOR + sass_directory
else
  ENV["SASS_PATH"] = sass_directory
end
