Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

require "yaml"

begin
  require "compass"
rescue LoadError
end

module LivingStyleGuide
  ROOT_PATH = File.join(File.dirname(__FILE__), "..")
  SASS_PATH = File.join(ROOT_PATH, "stylesheets")
  COMMANDS_REGEXP = %r{
      ^@(?<name>[\w\d_-]+)                       # @command-name
      (?:[ ](?<arguments>[^\n]*[^\{\n:]))?       # arg1; arg2; opt1: 1
      (?:
        [ ]*\{\n(?<braces>(?:.|\n)*?)\n\} |      # {\ncontent\ncontent\n}
        (?<indented>(?:\n+[ \t].*)+(?=\n|\Z)) |  # \n  content\n  content\n
        [ ]*:\n(?<colon>(?:.|\n)*?)(?:\n\n|\Z)   # :\ncontent\ncontent\n\n
      )?
    }x

  @@default_options = {
    default_language: :example,
    title: "Living Style Guide",
    root: "/"
  }

  def self.default_options
    @@default_options
  end

  def self.command(*keys, &block)
    Commands.command(*keys, &block)
  end

  def self.parse_data(data)
    if data
      if Psych.respond_to?(:safe_load)
        Psych.safe_load(data)
      else
        Psych.load(data)
      end
    end
  end

  def self.template(file, scope)
    file = "#{File.dirname(__FILE__)}/livingstyleguide/templates/#{file}"
    erb = File.read(file)
    ERB.new(erb).result(scope)
  end
end

require "livingstyleguide/version"
require "livingstyleguide/markdown_extensions"
require "livingstyleguide/document"
require "livingstyleguide/commands"
require "livingstyleguide/integration"
