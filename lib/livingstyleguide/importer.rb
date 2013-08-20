require 'sass-globbing'

class LivingStyleGuide::Importer < Sass::Globbing::Importer
  def find_relative(name, base, options, absolute = false)
    if name =~ /^(.+)\.s[ac]ss/
      path = options[:load_paths].first.root
      markdown_source_file = File.join(path, "#{$1}.md")
      if File.exist? markdown_source_file
        markdown_dest_file = options[:original_filename].sub(/s[ac]ss$/, 'md')
        File.open(markdown_dest_file, 'a') do |file|
          file.write File.read(markdown_source_file)
        end
      end
    end
    super(name, base, options, absolute)
  end
end

