module RubyFeatures
  class Conditions
    def initialize
      @conditions = {}
    end

    def push(condition_name, block)
      condition_name = condition_name.to_sym
      raise NameError.new("Such condition is already defined: #{condition_name}") if @conditions.has_key?(condition_name)

      @conditions[condition_name] = block
    end

    def normalize_asserts(asserts)
      asserts.inject({if: {}, unless: {}}) do |mem, (assert_type, asserts_per_type)|
        asserts_per_type = [asserts_per_type] unless asserts_per_type.kind_of?(Array)
        asserts_per_type.each do |assert_per_type|
          assert_per_type = {assert_per_type => true} unless assert_per_type.kind_of?(Hash)
          mem[assert_type].merge!(assert_per_type)
        end

        mem
      end
    end

    def match?(asserts, normalized = true)
      asserts = normalize_asserts(asserts) unless normalized

      asserts[:if].each do |condition_name, condition_value|
        return false unless value(condition_name) == condition_value
      end

      asserts[:unless].each do |condition_name, condition_value|
        return false if value(condition_name) == condition_value
      end

      true
    end

    def build_constant_postfix(*asserts)
      asserts = merge_asserts(asserts)

      RubyFeatures::Utils.camelize(
        asserts.sort.map { |assert_type, asserts_per_type|
          if asserts_per_type.empty?
            nil
          else
            "#{assert_type}_" + asserts_per_type.sort.map { |condition_name, condition_value|
              "#{condition_name}_is_#{condition_value}"
            }.join('_and_')
          end
        }.compact.join('_and_')
      )
    end

    private

    def value(condition_name)
      @conditions[condition_name] = @conditions[condition_name].call if @conditions[condition_name].respond_to?(:call)
      @conditions[condition_name]
    end

    def merge_asserts(asserts)
      asserts.inject({if: {}, unless: {}}) do |mem, assert|
        mem[:if].merge!(assert[:if])
        mem[:unless].merge!(assert[:unless])
        mem
      end
    end

  end
end
