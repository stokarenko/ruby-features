module RubyFeatures
  module Utils
    module ConstAccessor19
      def ruby_const_defined?(target, const_name)
        !!inject_const_parts_with_target(target, const_name){ |parent, submodule|
          parent && parent.const_defined?(submodule) ?
            parent.const_get(submodule) :
            false
        }
      end

      def ruby_const_get(target, const_name)
        inject_const_parts_with_target(target, const_name) do |parent, submodule|
          parent.const_get(submodule)
        end
      end

    end
  end
end
