require 'test_helper'

describe LivingStyleGuide::FilterHooks do

  before do
    @class = Class.new
    @class.class_eval do
      include Hooks
      include Hooks::InstanceHooks
      include LivingStyleGuide::FilterHooks
      define_hook :filter
    end
  end

  describe "running filters after each other" do
    it "should filter one filter" do
      @class.filter { |text| text * 2 }
      @class.run_filter_hook(:filter, "hello world").must_equal "hello worldhello world"
    end

    it "should filter several filter in a row" do
      @class.filter { |text| text * 2 }
      @class.filter { |text| text.gsub(/worldhello/, 'beautiful') }
      @class.run_filter_hook(:filter, "hello world").must_equal "hello beautiful world"
    end

    it "should work on instances" do
      @class.filter { |text| text * 2 }
      @class.new.run_filter_hook(:filter, "hello world").must_equal "hello worldhello world"
    end
  end

  describe "run only the latest added filter" do
    it "should should run only one filter" do
      @class.filter { |text| text.gsub(/animal/, 'fish') }
      @class.filter { |text| text.gsub(/animal/, 'bird') }
      @class.run_last_filter_hook(:filter, "the animal").must_equal "the bird"
    end

    it "should return the original string if no hooks are defined" do
      @class.run_last_filter_hook(:filter, "the animal").must_equal "the animal"
    end
  end

end

