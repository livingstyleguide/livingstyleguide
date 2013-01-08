module LivingStyleGuide::SassExtensions
end

require 'livingstyleguide/sass_extensions/functions'
require 'sass'

module Sass::Script::Functions
  include LivingStyleGuide::SassExtensions::Functions
end
