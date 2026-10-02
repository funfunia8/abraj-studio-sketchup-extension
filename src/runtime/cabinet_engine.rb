# frozen_string_literal: true

require_relative '../core/params'
require_relative '../core/cabinet'
require_relative '../reports/cut_list'
require_relative '../reports/bom'

module AbrajStudio
  module Runtime
    class CabinetEngine
      attr_reader :cabinet, :cut_list, :bom

      def initialize(params)
        @cabinet = Core::Cabinet.new(params)
        @cut_list = Reports::CutList.new(@cabinet)
        @bom = Reports::Bom.new(@cabinet)
      end

      def generate
        {
          summary: cabinet.summary,
          dimensions: cabinet.assembled_dimensions,
          shelf_positions: cabinet.shelf_positions,
          cut_list: cut_list.generate,
          bom: bom.generate
        }
      end
    end
  end
end
