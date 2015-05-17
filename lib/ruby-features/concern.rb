module RubyFeatures
  module Concern

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

    def _apply_to(target, feature_name)
      concern = self

      RubyFeatures::Utils.ruby_const_get(concern, "::#{target}").class_eval do
        if RubyFeatures::Utils.module_defined?(concern, 'ClassMethods')
          common_methods = methods & concern::ClassMethods.instance_methods
          raise NameError.new("Feature #{feature_name} tried to define already existing class methods: #{common_methods.inspect}") unless common_methods.empty?

          extend concern::ClassMethods
        end

        if RubyFeatures::Utils.module_defined?(concern, 'InstanceMethods')
          common_methods = instance_methods & concern::InstanceMethods.instance_methods
          raise NameError.new("Feature #{feature_name} tried to define already existing instance methods: #{common_methods.inspect}") unless common_methods.empty?

          include concern::InstanceMethods
        end

        concern.instance_variable_get(:@_applied_blocks).each do |applied_block|
          class_eval(&applied_block)
        end
      end
    end

  end
end
