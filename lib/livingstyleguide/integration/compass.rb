if defined?(Compass)
  base_directory = File.join(File.dirname(__FILE__), '..', '..', '..')
  Compass::Frameworks.register 'livingstyleguide', path: base_directory
end

