module RubyFeatures
  module Concern
    module Feature

      def apply
        unless applied?
          RubyFeatures.apply(*@_dependencies)

          @_apply_to_definitions.keys.each do |target|
            RubyFeatures::Lazy.apply(target) do
              _lazy_apply(target)
            end
          end

          @_applied = true
        end
      end

      def applied?
        @_applied
      end

      def _set_name(name)
        @_name = name
      end

      def name
        @_name
      end

      private

      def self.extended(base)
        base.instance_variable_set(:@_dependencies, [])
        base.instance_variable_set(:@_conditions, RubyFeatures::Conditions.new)
        base.instance_variable_set(:@_apply_to_definitions, {})
        base.instance_variable_set(:@_applied, false)
      end

      def dependencies(*feature_names)
        @_dependencies.push(*feature_names).uniq!
      end
      alias dependency dependencies

      def condition(condition_name, &block)
        @_conditions.push(condition_name, block)
      end

      def apply_to(target, asserts = {}, &block)
        target = target.to_s

        (@_apply_to_definitions[target] ||= []) << { asserts: asserts, block: block }
      end

      def _lazy_apply(target)
        apply_to_module = RubyFeatures::Utils.prepare_module!(self, target)
        apply_to_module.extend RubyFeatures::Concern::ApplyTo
        apply_to_module._apply(target, @_apply_to_definitions.delete(target), @_conditions)
      rescue NameError => e
        raise ApplyError.new("[#{name}] #{e.message}")
      end

    end
  end
end
