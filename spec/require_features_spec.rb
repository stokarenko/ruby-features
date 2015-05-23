describe RubyFeatures::Concern::Feature do

  prepare_test_class 'RequreFeaturesTestClass'

  before do
    define_test_feature('required_feature1') do
      class_methods do
        def required_method1; end
      end
    end

    define_test_feature('required_feature2') do
      class_methods do
        def required_method2; end
      end
    end

    define_test_feature('required_feature3') do
      class_methods do
        def required_method3; end
      end
    end
  end

  let(:main_feature) do
    RubyFeatures.define 'requre_features_test_class/main_feature' do
      dependency 'requre_features_test_class/required_feature1'
      dependencies 'requre_features_test_class/required_feature2', 'requre_features_test_class/required_feature3'
    end
  end

  it 'should apply required features' do
    expect{main_feature.apply}.to change{
      (1..3).map{|i| test_class.respond_to?("required_method#{i}")}
    }.from(Array.new(3, false)).to(Array.new(3, true))
  end

end
