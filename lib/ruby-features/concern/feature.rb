module RubyFeatures
  module Concern
    module Feature

      def self.extended(base)
        base.instance_variable_set(:@_apply_to, {})
        base.instance_variable_set(:@_applied, false)
      end

      def apply
        unless applied?
          @_apply_to.keys.each do |target|
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

      def apply_to(target, &block)
        target = target.to_s

        (@_apply_to[target] ||= []) << block
      end

      def _lazy_apply(target)
        apply_to_module = RubyFeatures::Utils.prepare_module!(self, target)
        apply_to_module.extend RubyFeatures::Concern::ApplyTo
        @_apply_to.delete(target).each { |block| apply_to_module.class_eval(&block) }
        apply_to_module._apply(target)
      rescue NameError => e
        raise ApplyError.new("[#{name}] #{e.message}")
      end

    end
  end
end
