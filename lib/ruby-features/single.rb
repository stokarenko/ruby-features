module RubyFeatures
  class Single

    attr_reader :name, :applied, :apply_to_blocks
    alias applied? applied

    def initialize(name, feature_body)
      @name = name = name.to_s
      raise NameError.new("Wrong feature name: #{name}") unless name.match(/^[\/_a-z\d]+$/)

      @apply_to_blocks = {}
      @applied = false

      instance_eval(&feature_body) if feature_body
    end

    def apply
      unless applied?
        Mixins.build_and_apply!(self)

        @apply_to_blocks = nil
        @applied = true
      end
    end

    private

    def apply_to(target, &block)
      target = target.to_s

      @apply_to_blocks[target] ||= []
      @apply_to_blocks[target] << block
    end

  end
end
