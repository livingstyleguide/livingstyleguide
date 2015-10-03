Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

require "yaml"

begin
  require "compass"
rescue LoadError
end

module LivingStyleGuide
  @@default_options = {
    default_language: :example,
    title: "Living Style Guide",
    header: %Q(<h1 class="lsg--page-title">Living Style Guide</h1>),
    footer: %Q(<div class="lsg--footer"><a class="lsg--logo" href="http://livingstyleguide.org">Made with the LivingStyleGuide gem.</a></div>),
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
end

require "livingstyleguide/version"
require "livingstyleguide/markdown_extensions"
require "livingstyleguide/document"
require "livingstyleguide/commands"
require "livingstyleguide/integration"
