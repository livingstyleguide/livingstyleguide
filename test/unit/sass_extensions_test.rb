require 'test_helper'

class SassExtensionsTest < Test::Unit::TestCase
  def test_list_variables_for_file
    assert_equal 'my-wonderful_red blue', evaluate(%Q(list-variables("variables/colors.scss")))
  end

  def test_list_variables_for_scss_files_without_extension
    assert_equal 'my-wonderful_red blue', evaluate(%Q(list-variables("variables/colors")))
  end

  def test_list_variables_for_sass_files_without_extension
    assert_equal 'blue green', evaluate(%Q(list-variables("variables/other-colors")))
  end

  def test_list_variables_for_directories
    assert_equal 'my-wonderful_red blue green', evaluate(%Q(list-variables("variables/*")))
  end

protected
  def evaluate(value)
    Sass::Script::Parser.parse(value, 0, 0).perform(Sass::Environment.new).to_s
  end
end
