module RubyFeatures
  module Utils
    module ConstAccessor19
      def ruby_const_defined?(target, const_parts)
        const_parts = const_parts.split('::') unless const_parts.kind_of?(Array)

        first_const_part = const_parts.shift
        first_const_defined = target.const_defined?(first_const_part)

        !first_const_defined || const_parts.empty? ?
          first_const_defined :
          ruby_const_defined?(target.const_get(first_const_part), const_parts)
      end

      def ruby_const_get(target, const_parts)
        const_parts = const_parts.split('::') unless const_parts.kind_of?(Array)

        first_const_part = const_parts.shift
        if first_const_part == ''
          target = ::Object
          first_const_part = const_parts.shift
        end

        first_const = target.const_get(first_const_part)

        const_parts.empty? ?
          first_const :
          ruby_const_get(first_const, const_parts)
      end
    end
  end
end
