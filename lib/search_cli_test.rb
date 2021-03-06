require 'minitest/spec'
require 'minitest/autorun'
require './lib/search_cli.rb'
require 'stringio'

class SearchCliTest < MiniTest::Test
  def setup
    @organizations = FormElement.new('./resources/organizations-test.json')
    @hash = @organizations.get_hash_by_address
    interface = SearchInterface.new('./resources/organizations.json','./resources/users.json','./resources/tickets.json')
  end

  def test_find_number_in_hash
    assert_equal true, @organizations.find_value_in_nested_hash({'id' => 101}, 101), "Cannot find number in hash"
  end

  def test_find_string_in_hash
    assert_equal true, @organizations.find_value_in_nested_hash({'id' => '101'}, '101'), "Cannot find string in hash"
  end

  # write a test for input
  def test_io
    string_io = StringIO.new
    string_io.puts '0'
    string_io.rewind
    $stdin = string_io

    assert_equal '0', gets.chomp, "input is not a 0"
  end
end
