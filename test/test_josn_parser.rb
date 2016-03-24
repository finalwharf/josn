require_relative '../src/josn_parser'
require 'test/unit'
require 'json'

class TestJosnParser < Test::Unit::TestCase
  def test_simple_json
    hash = { 'a' => 'AAA', 'b' => {'c' => 0.1, 'd' => 3.3}, 'z' => ['y', -3, []] }
    json = '{a: AAA, b:{c:.1, d:3.3 },z:["y", -3, []]}'

    assert_equal(hash, Josn.parse(json))
  end

  def test_complex_broken_json
    hash  = { "key" => [["value_1","value_2"], ["value_3","value4"]], "5" => "10:00AM"}
    json = '{key:[[value_1, value_2],[value_3, value4]], 5:10:00AM]}'

    assert_equal(hash, Josn.parse(json))
  end

  def test_empty_json
    assert_equal({}, Josn.parse('{}'))
  end

  def test_JSON_json
    json = JSON.dump(
      'working'   => true,
      'broken'    => false,
      'im_a_null' => nil,
      'gender'    => 'male',
      'name'      => 'Danny',
      'age'       => 128,
      128         => 'age',
      'quoted'    => '"quoted"'
    )

    puts
    puts JSON.parse(json)
    puts
    assert_equal(JSON.parse(json), Josn.parse(json))
  end
end
