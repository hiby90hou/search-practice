require 'minitest/spec'
require 'minitest/autorun'
require './lib/search_cli.rb'

class SearchCliTest < MiniTest::Test
  def setup
    @organizations = FormElement.new('./resources/organizations-test.json')
    @hash = @organizations.get_hash_by_address
  end

  def test_find_number_in_hash
    assert_equal true, @organizations.find_value_in_nested_hash({'id' => 101}, 101), "Cannot find number in hash"
  end

  def test_find_string_in_hash
    assert_equal true, @organizations.find_value_in_nested_hash({'id' => '101'}, '101'), "Cannot find string in hash"
  end
end
