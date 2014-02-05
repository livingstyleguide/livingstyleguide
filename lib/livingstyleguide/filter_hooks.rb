module LivingStyleGuide::FilterHooks
  def self.included(base)
    base.class_eval do
      extend ClassMethods
      include ClassMethods
    end
  end

  module ClassMethods
    def run_filter_hook(name, source)
      _hooks[name].each do |callback|
        if callback.kind_of?(Symbol)
          source = send(callback, source)
        else
          source = instance_exec(source, &callback)
        end
      end
      source
    end
  end
end


