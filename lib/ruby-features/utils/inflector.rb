module RubyFeatures
  module Utils
    module Inflector

      def camelize(string)
        string.gsub(/([a-z\d]+)/i) { $1.capitalize }.gsub(/[-_]/, '').gsub('/', '::')
      end

      def underscore(string)
        string.gsub(/([A-Z][a-z\d]*)/){ "_#{$1.downcase}" }.
        gsub(/^_/, '').
        gsub('::', '/')
      end

    end
  end
end
