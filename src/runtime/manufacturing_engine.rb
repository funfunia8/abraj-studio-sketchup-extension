# frozen_string_literal: true

require_relative '../core/params'
require_relative '../core/cabinet_spec'
require_relative '../reports/detailed_cut_list'
require_relative '../reports/detailed_bom'

module AbrajStudio
  module Runtime
    class ManufacturingEngine
      attr_reader :cabinet_spec, :cut_list_report, :bom_report

      def initialize(params)
        @params = params
        @cabinet_spec = Core::CabinetSpec.new(params)
        @cut_list_report = Reports::DetailedCutList.new(@cabinet_spec)
        @bom_report = Reports::DetailedBom.new(@cabinet_spec)
      end

      def generate_complete_project
        {
          project_info: {
            name: 'Base Cabinet Manufacturing Project',
            created_at: Time.now.to_s,
            version: '1.0'
          },
          cabinet: @cabinet_spec.summary,
          dimensions: @cabinet_spec.assembled_dimensions,
          parts: @cabinet_spec.parts_list,
          cut_list: @cut_list_report.generate,
          bom: @bom_report.generate,
          shelf_positions: @cabinet_spec.shelf_positions
        }
      end

      def export_to_json
        JSON.pretty_generate(generate_complete_project)
      end

      def export_to_hash
        generate_complete_project
      end
    end
  end
end
