describe RubyFeatures do

  class FindAndApplyTestClass; end

  RubyFeatures.define 'find_and_apply_test_class/manual' do
    apply_to 'FindAndApplyTestClass' do

      class_methods do
        def manual_method; end
      end

    end
  end

  it 'should find features in path and apply all on demand' do
    features_container = subject.find_in_path(File.expand_path('../ruby_features', __FILE__))

    expect(FindAndApplyTestClass).to_not respond_to(:root_method)
    expect(FindAndApplyTestClass).to_not respond_to(:nested_method)

    features_container.apply_all

    expect(FindAndApplyTestClass).to respond_to(:root_method)
    expect(FindAndApplyTestClass).to respond_to(:nested_method)
  end

  it 'should apply features by name' do
    expect(FindAndApplyTestClass).to_not respond_to(:manual_method)
    RubyFeatures.apply('find_and_apply_test_class/manual')
    expect(FindAndApplyTestClass).to respond_to(:manual_method)
  end

end
