module RubyFeatures
  module Concern

    def _apply(target, feature_name)
      target_class = RubyFeatures::Utils.ruby_const_get(self, "::#{target}")

      _apply_methods(target_class, feature_name, :class)
      _apply_methods(target_class, feature_name, :instance)
      _apply_applied_blocks(target_class)
    end

    private

    def self.extended(base)
      base.instance_variable_set(:@_applied_blocks, [])
    end

    def applied(&block)
      instance_variable_get(:@_applied_blocks) << block
    end

    def class_methods(&block)
      RubyFeatures::Utils.prepare_module(self, 'ClassMethods').class_eval(&block)
    end

    def instance_methods(&block)
      RubyFeatures::Utils.prepare_module(self, 'InstanceMethods').class_eval(&block)
    end

    def _apply_methods(target_class, feature_name, methods_type)
      methods_module_name = "#{methods_type.capitalize}Methods"

      if RubyFeatures::Utils.module_defined?(self, methods_module_name)
        methods_module = const_get(methods_module_name)
        common_methods = target_class.public_send(:"#{'instance_' if methods_type == :instance}methods") & methods_module.instance_methods
        raise NameError.new("Feature #{feature_name} tried to define already existing #{methods_type} methods: #{common_methods.inspect}") unless common_methods.empty?

        target_class.send((methods_type == :instance ? :include : :extend), methods_module)
      end

    end

    def _apply_applied_blocks(target_class)
      instance_variable_get(:@_applied_blocks).each do |applied_block|
        target_class.class_eval(&applied_block)
      end
    end

  end
end
