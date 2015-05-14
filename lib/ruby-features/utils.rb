module RubyFeatures
  module Utils
    class << self
      def module_defined?(target, module_name)
        target.const_defined?(module_name) && target.const_get(module_name).name.start_with?(target.name)
      end

      def prepare_module!(target, module_name)
        module_defined?(target, module_name) ?
          raise("Module already initiated: #{target.name}::#{module_name}") :
          _prepare_module(target, module_name.split('::'))
      end

      def prepare_module(target, module_name)
        module_defined?(target, module_name) ?
          target.const_get(module_name) :
          _prepare_module(target, module_name.split('::'))
      end

      private

      def _prepare_module(target, modules)
        new_target = target.const_set(modules.shift, Module.new)
        modules.empty? ?
          new_target :
          _prepare_module(new_target, modules)
      end
    end
  end
end
