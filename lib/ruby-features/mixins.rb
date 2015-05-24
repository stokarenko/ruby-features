module RubyFeatures
  module Mixins
    class << self

      def new(feature_name, feature_body)
        RubyFeatures::Utils.prepare_module!(
          self,
          RubyFeatures::Utils.camelize(feature_name)
        ).tap do |feature_module|
          feature_module.extend RubyFeatures::Concern::Feature
          feature_module._set_feature_name(feature_name)
          feature_module.class_eval(&feature_body) if feature_body
        end
      end

    end
  end
end
