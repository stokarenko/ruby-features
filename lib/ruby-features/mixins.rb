module RubyFeatures
  module Mixins
    class << self

      def build_and_apply!(feature)
        feature_module = RubyFeatures::Utils.prepare_module!(
          self,
          RubyFeatures::Utils.camelize(feature.name)
        )

        feature.apply_to_blocks.each do |target, blocks|
          RubyFeatures::Lazy.apply(target) do
            _lazy_build_and_apply!(feature, feature_module, target, blocks)
          end
        end
      end

      def _lazy_build_and_apply!(feature, feature_module, target, blocks)
        lazy_module = RubyFeatures::Utils.prepare_module!(feature_module, target)
        lazy_module.extend RubyFeatures::Concern
        blocks.each { |block| lazy_module.class_eval(&block) }
        lazy_module._apply(target, feature.name)
      end

    end
  end
end
