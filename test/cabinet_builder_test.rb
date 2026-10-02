# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../src/core/params'
require_relative '../src/sketchup/cabinet_builder'

class CabinetBuilderTest < Minitest::Test
  def setup
    @params = AbrajStudio::Core::Params.new(width: 600, height: 900, depth: 600, material: 'MDF', thickness: 18, shelf_count: 1, door_type: 'panel')
    @builder = AbrajStudio::SketchUp::CabinetBuilder.new(@params)
  end

  def test_builder_creates_base_cabinet_structure
    result = @builder.build

    assert_equal 'Base Cabinet', result[:type]
    assert_equal 600, result[:width]
    assert_equal 900, result[:height]
    assert_equal 600, result[:depth]
    assert_equal 'MDF', result[:material]
    assert_equal 1, result[:shelves].length
    assert_equal 'panel', result[:door][:type]
  end
end
