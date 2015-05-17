module RubyFeatures
  module Utils
    class << self

      def module_defined?(target, module_name)
        target.const_defined?(module_name) && target.const_get(module_name).name.start_with?(target.name)
      end

      def prepare_module!(target, module_name)
        module_defined?(target, module_name) ?
          raise(NameError.new("Module already initiated: #{target.name}::#{module_name}")) :
          prepare_module(target, module_name)
      end

      def prepare_module(target, modules)
        modules = modules.split('::') unless modules.kind_of?(Array)

        first_submodule = modules.shift
        new_target = module_defined?(target, first_submodule) ?
          target.const_get(first_submodule) :
          target.const_set(first_submodule, Module.new)

        modules.empty? ?
          new_target :
          prepare_module(new_target, modules)
      end

      def modulize(string)
        string.gsub(/([a-z\d]+)/i) { $1.capitalize }.gsub(/[-_]/, '').gsub('/', '::')
      end

    end
  end
end
