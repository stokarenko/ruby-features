module RubyFeatures
  class Single

    attr_reader :name, :applied, :include_in_blocks
    alias applied? applied


    def initialize(name, feature_body)
      @name = name.to_s

      @include_in_blocks = {}
      @applied = false

      instance_eval(&feature_body)
    end

    def apply
      unless applied?
        Mixins.build_and_apply!(self)

        @include_in_blocks = nil
        @applied = true
      end
    end

    private

    def include_in(target, &block)
      target = target.to_s

      @include_in_blocks[target] ||= []
      @include_in_blocks[target] << block
    end

  end
end
