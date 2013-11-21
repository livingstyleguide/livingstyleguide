require 'sass-globbing'

class LivingStyleGuide::Importer < Sass::Globbing::Importer
  def find_relative(name, base, options, absolute = false)
    if name =~ /^(.+)\.s[ac]ss$|^(\*|[a-z0-9_\/-])+$/
      path = File.expand_path(File.dirname(base))
      file = "#{path}/#{name.sub(/\..+$/, '')}.md"
      file.sub!(/(.*)\//, '\\1/_') unless file =~ /\/_/

      if File.exist? file
        LivingStyleGuide.add_markdown File.read(file)
      end

      super(name, base, options, absolute)
    end
  end
end

