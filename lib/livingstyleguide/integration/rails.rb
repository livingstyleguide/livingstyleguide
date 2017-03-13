if defined?(Rails) && defined?(Rails::Railtie) && defined?(Sprockets)
  require "rails"
  class LivingStyleGuideRailtie < Rails::Railtie
    initializer "living_style_guide.assets" do |app|
      Rails.application.config.assets.configure do |env|
        LivingStyleGuideTransformer.register(env)
      end
      LivingStyleGuide.default_options[:scss_template] =
        ::Sass::Rails::ScssTemplate
      app.config.assets.paths << ::LivingStyleGuide::SASS_PATH
    end
  end
end
