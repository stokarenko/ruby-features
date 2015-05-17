module RubyFeatures
  class Container

    def initialize(feature_names)
      @feature_names = feature_names
    end

    def apply_all
      RubyFeatures.apply(*@feature_names)
    end

  end
end
