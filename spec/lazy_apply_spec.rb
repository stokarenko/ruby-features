if RubyFeatures.active_support_available?
  describe RubyFeatures::Lazy do

    it 'should use ActiveSupport lazy load' do
      RubyFeatures.define 'lazy_load/active_support' do
        apply_to 'ActiveRecord::Base' do
          class_methods do
            def lazy_active_support; end
          end
        end
      end.apply
      expect(defined?(ActiveRecord)).to_not be true

      require 'active_record'
      expect(ActiveRecord::Base).to respond_to(:lazy_active_support)
    end

  end
end
