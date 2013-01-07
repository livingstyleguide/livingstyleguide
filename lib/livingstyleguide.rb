require 'livingstyleguide/version'
require 'livingstyleguide/sass_extensions'
require 'livingstyleguide/variables_importer'
require 'sass/plugin'

module LivingStyleGuide
end

Compass.configuration.add_import_path LivingStyleGuide::VariablesImporter.new
