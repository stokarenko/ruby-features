module RubyFeatures
  module Utils
    module InflectorActiveSupport

      def camelize(string)
        ActiveSupport::Inflector.camelize(string)
      end

      def underscore(string)
        ActiveSupport::Inflector.underscore(string)
      end

    end
  end
end
