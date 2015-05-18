module RubyFeatures
  module Utils

    autoload :ConstAccessor19,        'ruby-features/utils/const_accessor_19'
    autoload :ConstAccessor20,        'ruby-features/utils/const_accessor_20'

    autoload :Inflector,              'ruby-features/utils/inflector'
    autoload :InflectorActiveSupport, 'ruby-features/utils/inflector_active_support'

    begin
      const_defined?('Some::Const')
      extend ConstAccessor20
    rescue NameError
      extend ConstAccessor19
    end

    extend RubyFeatures.active_support_available? ?
      InflectorActiveSupport :
      Inflector

    class << self

      def module_defined?(target, module_name)
        ruby_const_defined?(target, module_name) && ruby_const_get(target, module_name).name.start_with?(target.name)
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

    end
  end
end
