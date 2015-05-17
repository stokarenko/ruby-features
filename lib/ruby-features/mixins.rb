module RubyFeatures
  module Mixins
    class << self

      def build_and_apply!(feature)
        feature_module_name = RubyFeatures::Utils.modulize(feature.name)

        RubyFeatures::Utils.prepare_module!(self, feature_module_name).class_eval do
          feature.apply_to_blocks.each do |target, blocks|
            RubyFeatures::Utils.prepare_module!(self, target).class_eval do
              extend RubyFeatures::Concern
              blocks.each { |block| class_eval(&block) }
              _apply_to(target)
            end
          end
        end
      end

    end
  end
end
