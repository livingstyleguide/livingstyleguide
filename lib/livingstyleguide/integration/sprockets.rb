if defined?(Sprockets)
  begin
    require "sprockets"

    class LivingStyleGuideTransformer
      def initialize(filename)
        @filename = filename
        @source = yield
      end

      def render(context, _)
        self.class.run(@filename, @source, context)
      end

      def self.run(filename, source, context)
        doc = LivingStyleGuide::Document.new(filename) { source }
        doc.render(context)
      end

      def self.call(input)
        filename = input[:filename]
        source = input[:data]
        context = input[:environment].context_class.new(input)

        result = run(filename, source, context)
        context.metadata.merge(data: result)
      end

      def self.register(env)
        if env.respond_to?(:register_transformer)
          env.register_mime_type("text/lsg",
                                 extensions: [".lsg"],
                                 charset: :unicode)
          env.register_transformer("text/lsg", "text/html",
                                   LivingStyleGuideTransformer)
        end

        if env.respond_to?(:register_engine)
          args = [".lsg", ::LivingStyleGuide::Document]
          if Sprockets::VERSION.start_with?("3")
            args << { mime_type: "text/html", silence_deprecation: true }
          end
          env.register_engine(*args)
        end

        if env.respond_to?(:append_path)
          env.append_path(::LivingStyleGuide::SASS_PATH)
        end
      end
    end

    LivingStyleGuideTransformer.register(Sprockets)
  rescue LoadError
  end
end
