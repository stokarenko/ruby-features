module RubyFeatures
  module Concern
    module ApplyTo

      def _apply(target, apply_to_definitions, conditions)
        _with_instance_variable(:@_conditions, conditions) do
          _build_mixins(apply_to_definitions)
        end

        target_class = RubyFeatures::Utils.ruby_const_get(self, "::#{target}")

        _apply_methods(target_class)
        _apply_applied_blocks(target_class)
      end

      private

      def self.extended(base)
        base.instance_variable_set(:@_applied_blocks, [])
      end

      def applied(asserts = {}, &block)
        if @_conditions.match?(asserts, false)
          @_applied_blocks << block
        end
      end

      def class_methods(asserts = {}, &block)
        _methods('Extend', asserts, block)
      end

      def instance_methods(asserts = {}, &block)
        _methods('Include', asserts, block)
      end

      def _apply_methods(target_class)
        constants.each do |constant|
          mixin_method, existing_methods_method = case(constant)
          when /^Extend/ then [:extend, :methods]
          when /^Include/ then [:include, :instance_methods]
          else raise ArgumentError.new("Wrong mixin constant: #{constant}")
          end

          mixin = const_get(constant)

          common_methods = target_class.public_send(existing_methods_method) & mixin.instance_methods
          raise NameError.new("Tried to #{mixin_method} already existing methods: #{common_methods.inspect}") unless common_methods.empty?

          target_class.send(mixin_method, mixin)
        end
      end

      def _apply_applied_blocks(target_class)
        @_applied_blocks.each do |applied_block|
          target_class.class_eval(&applied_block)
        end
      end

      def _methods(mixin_prefix, asserts, block)
        asserts = @_conditions.normalize_asserts(asserts)

        if @_conditions.match?(asserts)
          RubyFeatures::Utils.prepare_module(self, "#{mixin_prefix}#{@_conditions.build_constant_postfix(@_global_asserts, asserts)}").class_eval(&block)
        end
      end

      def _with_instance_variable(variable_name, value)
        instance_variable_set(variable_name, value)
        yield
        remove_instance_variable(variable_name)
      end

      def _build_mixins(apply_to_definitions)
        apply_to_definitions.each do |apply_to_definition|
          global_asserts = @_conditions.normalize_asserts(apply_to_definition[:asserts])
          if @_conditions.match?(global_asserts)
            _with_instance_variable(:@_global_asserts, global_asserts) do
              class_eval(&apply_to_definition[:block])
            end
          end
        end
      end

    end
  end
end
