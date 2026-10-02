# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../src/core/params'
require_relative '../src/core/cabinet'
require_relative '../src/reports/cut_list'
require_relative '../src/reports/bom'

class CabinetEngineTest < Minitest::Test
  def setup
    @params = AbrajStudio::Core::Params.new(width: 600, height: 900, depth: 600, material: 'MDF', thickness: 18)
    @cabinet = AbrajStudio::Core::Cabinet.new(@params)
  end

  def test_cabinet_summary
    summary = @cabinet.summary

    assert_equal 'Base Cabinet', summary[:type]
    assert_equal 600, summary[:width]
    assert_equal 900, summary[:height]
    assert_equal 600, summary[:depth]
  end

  def test_shelf_positions_count
    positions = @cabinet.shelf_positions
    assert_equal 1, positions.length
  end

  def test_cut_list_has_parts
    cut_list = AbrajStudio::Reports::CutList.new(@cabinet).generate
    assert_operator cut_list.length, :>, 0
  end

  def test_bom_has_items
    bom = AbrajStudio::Reports::Bom.new(@cabinet).generate
    assert_operator bom.length, :>, 0
  end
end
