module LivingStyleGuide::FilterHooks
  def self.included(base)
    base.class_eval do
      extend Methods
      include Methods
    end
  end

  module Methods
    def run_filter_hook(name, source)
      _hooks[name].each do |hook|
        source = run_single_hook(hook, source)
      end
      source
    end

    def run_last_filter_hook(name, source)
      run_single_hook(_hooks[name].last, source)
    end

    private
    def run_single_hook(hook, source)
      if hook.kind_of?(Symbol)
        send(hook, source)
      else
        instance_exec(source, &hook)
      end
    end
  end
end


