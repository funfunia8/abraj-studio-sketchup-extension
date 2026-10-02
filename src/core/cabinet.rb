# frozen_string_literal: true

module AbrajStudio
  module Core
    class Cabinet
      attr_reader :params

      def initialize(params)
        @params = params
        params.validate!
      end

      def summary
        {
          type: 'Base Cabinet',
          width: params.width,
          height: params.height,
          depth: params.depth,
          thickness: params.thickness,
          material: params.material,
          door_type: params.door_type,
          drawer_type: params.drawer_type,
          hinge_type: params.hinge_type,
          handle_type: params.handle_type,
          shelf_count: params.shelf_count
        }
      end

      def assembled_dimensions
        {
          width: params.width,
          height: params.height,
          depth: params.depth,
          carcass_thickness: params.thickness,
          clearance: params.clearance
        }
      end

      def parts
        shelf_qty = params.shelf_count.to_i
        sides = [
          build_part('Left Side', params.height, params.depth, 'panel'),
          build_part('Right Side', params.height, params.depth, 'panel')
        ]

        carcass = [
          build_part('Top Panel', params.width, params.depth, 'panel'),
          build_part('Bottom Panel', params.width, params.depth, 'panel'),
          build_part('Back Panel', params.width, params.height, 'panel')
        ]

        shelves = Array.new(shelf_qty) do |index|
          build_part("Shelf #{index + 1}", params.width, params.depth, 'shelf')
        end

        doors = [
          build_part('Door 1', params.width, params.height, 'door')
        ]

        sides + carcass + shelves + doors
      end

      def shelf_positions
        return [] if params.shelf_count.to_i <= 0

        spacing = (params.height - (params.thickness * (params.shelf_count + 1))) / params.shelf_count
        (1..params.shelf_count).map do |index|
          params.thickness * index + spacing * (index - 1)
        end
      end

      private

      def build_part(name, x, y, kind)
        {
          name: name,
          kind: kind,
          x: x,
          y: y,
          material: params.material,
          thickness: params.thickness,
          edge_band: params.edge_band,
          quantity: 1
        }
      end
    end
  end
end
