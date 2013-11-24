Compass.configuration.add_import_path LivingStyleGuide::VariablesImporter.new

base_directory = File.join(File.dirname(__FILE__), '..', '..', '..')
Compass::Frameworks.register 'livingstyleguide', path: base_directory

