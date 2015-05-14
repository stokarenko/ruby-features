module RubyFeatures
  module Concern

    private

    def self.extended(base)
      base.instance_variable_set(:@_included_blocks, [])
    end

    def included(&block)
      instance_variable_get(:@_included_blocks) << block
    end

    def class_methods(&block)
      RubyFeatures::Utils.prepare_module(self, 'ClassMethods').class_eval(&block)
    end

    def instance_methods(&block)
      RubyFeatures::Utils.prepare_module(self, 'InstanceMethods').class_eval(&block)
    end

    def _apply_to(target)
      concern = self

      "::#{target}".constantize.class_eval do
        extend concern::ClassMethods if RubyFeatures::Utils.module_defined?(concern, 'ClassMethods')
        include concern::InstanceMethods if RubyFeatures::Utils.module_defined?(concern, 'InstanceMethods')

        concern.instance_variable_get(:@_included_blocks).each do |included_block|
          class_eval(&included_block)
        end
      end
    end

  end
end
