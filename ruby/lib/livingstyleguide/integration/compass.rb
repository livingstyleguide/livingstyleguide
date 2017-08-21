if defined?(Compass)
  options = {
    path: LivingStyleGuide::ROOT_PATH,
    stylesheets_directory: LivingStyleGuide::SASS_PATH
  }
  Compass::Frameworks.register "livingstyleguide", options
end
