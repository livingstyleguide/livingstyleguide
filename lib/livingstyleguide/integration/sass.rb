sass_directory = LivingStyleGuide::SASS_PATH
if ENV.has_key?("SASS_PATH")
  ENV["SASS_PATH"] = ENV["SASS_PATH"] + File::PATH_SEPARATOR + sass_directory
else
  ENV["SASS_PATH"] = sass_directory
end
