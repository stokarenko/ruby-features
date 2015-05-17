describe RubyFeatures do

  prepare_test_class('FindAndApplyTestClass')

  it 'should find features in path and apply all on demand' do
    features_container = subject.find_in_path(File.expand_path('../ruby_features', __FILE__))

    expect(test_class).to_not respond_to(:root_method)
    expect(test_class).to_not respond_to(:nested_method)

    features_container.apply_all

    expect(test_class).to respond_to(:root_method)
    expect(test_class).to respond_to(:nested_method)
  end

  it 'should apply features by name' do

    define_test_feature('manual') do
      class_methods do
        def manual_method; end
      end
    end

    expect(test_class).to_not respond_to(:manual_method)
    RubyFeatures.apply('find_and_apply_test_class/manual')
    expect(test_class).to respond_to(:manual_method)
  end

  it 'should raise error if trying to apply not existing feature' do
    expect{
      RubyFeatures.apply('find_and_apply_test_class/not_existing_feature')
    }.to raise_error(/Such feature is not registered/)
  end

  it 'should raise error if trying to define already registered feature' do
    RubyFeatures.define('find_and_apply_test_class/duplicate_feature')

    expect{
      RubyFeatures.define('find_and_apply_test_class/duplicate_feature')
    }.to raise_error(/Such feature is already registered/)
  end

end
