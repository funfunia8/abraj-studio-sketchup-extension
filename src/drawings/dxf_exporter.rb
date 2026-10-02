# frozen_string_literal: true

module AbrajStudio
  module Drawings
    class DxfExporter
      def initialize(cabinet_spec)
        @cabinet = cabinet_spec
      end

      def export_parts_to_dxf
        dxf_data = {
          version: '2013',
          units: 'mm',
          layers: create_layers,
          entities: generate_dxf_entities
        }
        dxf_data
      end

      private

      def create_layers
        {
          '0' => { name: 'Defpoints', color: 7 },
          'PARTS' => { name: 'Parts', color: 3 },
          'HOLES' => { name: 'Holes', color: 5 },
          'EDGES' => { name: 'Edges', color: 2 },
          'DIMENSIONS' => { name: 'Dimensions', color: 4 }
        }
      end

      def generate_dxf_entities
        entities = []
        offset_y = 0

        @cabinet.parts_list.each_with_index do |part, index|
          x = 10
          y = offset_y

          entities << {
            type: 'LINE',
            layer: 'PARTS',
            x1: x,
            y1: y,
            x2: x + part[:dimensions][:width],
            y2: y
          }

          entities << {
            type: 'LINE',
            layer: 'PARTS',
            x1: x + part[:dimensions][:width],
            y1: y,
            x2: x + part[:dimensions][:width],
            y2: y + (part[:dimensions][:height] || part[:dimensions][:depth])
          }

          entities << {
            type: 'LINE',
            layer: 'PARTS',
            x1: x + part[:dimensions][:width],
            y1: y + (part[:dimensions][:height] || part[:dimensions][:depth]),
            x2: x,
            y2: y + (part[:dimensions][:height] || part[:dimensions][:depth])
          }

          entities << {
            type: 'LINE',
            layer: 'PARTS',
            x1: x,
            y1: y + (part[:dimensions][:height] || part[:dimensions][:depth]),
            x2: x,
            y2: y
          }

          entities << {
            type: 'TEXT',
            layer: 'PARTS',
            x: x + 5,
            y: y + 5,
            text: "#{index + 1}. #{part[:name]}",
            height: 3
          }

          offset_y += (part[:dimensions][:height] || part[:dimensions][:depth]) + 20
        end

        entities
      end
    end
  end
end
