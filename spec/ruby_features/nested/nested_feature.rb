RubyFeatures.define 'find_and_apply_test_class/nested' do
  apply_to 'FindAndApplyTestClass' do

    class_methods do
      def nested_method; end
    end

  end
end
