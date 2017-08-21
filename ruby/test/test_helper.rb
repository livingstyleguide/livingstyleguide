require "minitest/autorun"
require "compass"
require "livingstyleguide"
require "heredoc_unindent"

require "tilt/erubis"
require "tilt/redcarpet"
require "tilt/haml"
require "tilt/coffee"

Compass.configuration.add_import_path "."

def parse_file(filename)
  filename = File.join(File.dirname(__FILE__), "fixtures", filename.split("/"))
  syntax   = filename[-4..-1].to_sym
  syntax   = :scss unless [:scss, :sass].include?(syntax)
  options  = {
    filename: filename,
    load_paths: [File.dirname(filename)],
    syntax: syntax,
    cache: false,
    read_cache: false
  }
  Sass::Engine.new(File.read(filename), options)
end

def normalize(html)
  html.gsub!(/\s+/, " ")
  html.gsub!("><", "> <")
  html.strip!
  html
end

require "i18n"
I18n.enforce_available_locales = false

FileUtils.rm_rf(".sass-cache")
