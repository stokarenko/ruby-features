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

      def prepare_module(target, module_name)
        inject_const_parts_with_target(target, module_name) do |parent, submodule|
          module_defined?(parent, submodule) ?
            parent.const_get(submodule) :
            parent.const_set(submodule, Module.new)
        end
      end

      private

      def inject_const_parts_with_target(target, const_name, &block)
        const_parts = const_name.split('::')
        if const_parts.first == ''
          target = ::Object
          const_parts.shift
        end

        const_parts.inject(target, &block)
      end

    end
  end
end
