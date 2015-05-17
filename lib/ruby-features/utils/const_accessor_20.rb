module RubyFeatures
  module Utils
    module ConstAccessor20
      def ruby_const_defined?(target, const_name)
        target.const_defined?(const_name)
      end

      def ruby_const_get(target, const_name)
        target.const_get(const_name)
      end
    end
  end
end
