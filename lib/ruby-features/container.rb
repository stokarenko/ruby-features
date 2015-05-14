module RubyFeatures
  class Container

    cattr_reader :load_mutex, :current
    @@load_mutex = Mutex.new

    attr_reader :features

    def initialize(folders)
      load_mutex.synchronize do
        @features = []

        @@current = self

        Dir[*folders.map{|folder| File.join(folder, '**', '*_feature.rb') }].each do |file|
          load file
        end

        @@current = nil
      end
    end

    def apply
      features.map(&:apply)
      self
    end

    private

    def self.push_to_current(feature)
      current.features << feature if @@current
    end

  end
end
