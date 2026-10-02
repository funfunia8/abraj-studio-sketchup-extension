# frozen_string_literal: true

module AbrajStudio
  module Core
    class CabinetSpec
      attr_reader :params, :parts, :shelf_positions, :geometry

      def initialize(params)
        @params = params
        params.validate!
        @geometry = GeometryEngine
        @parts = []
        @shelf_positions = []
        generate_parts
        calculate_shelf_positions
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
          shelf_count: params.shelf_count,
          edge_band: params.edge_band,
          total_parts_count: @parts.length,
          shelf_positions: @shelf_positions
        }
      end

      def assembled_dimensions
        {
          external_width: params.width,
          external_height: params.height,
          external_depth: params.depth,
          internal_width: geometry.calculate_internal_width(params.width, params.thickness),
          internal_height: geometry.calculate_internal_height(params.height, params.thickness),
          internal_depth: geometry.calculate_internal_width(params.depth, params.thickness),
          carcass_thickness: params.thickness,
          clearance: params.clearance
        }
      end

      def parts_list
        @parts
      end

      private

      def generate_parts
        # Left and Right sides
        @parts << PartFactory.create_panel(
          'Left Side',
          params.height,
          params.depth,
          params.material,
          params.thickness,
          params.edge_band,
          1
        )

        @parts << PartFactory.create_panel(
          'Right Side',
          params.height,
          params.depth,
          params.material,
          params.thickness,
          params.edge_band,
          1
        )

        # Top and Bottom panels
        internal_width = geometry.calculate_internal_width(params.width, params.thickness)

        @parts << PartFactory.create_panel(
          'Top Panel',
          internal_width,
          params.depth,
          params.material,
          params.thickness,
          params.edge_band,
          1
        )

        @parts << PartFactory.create_panel(
          'Bottom Panel',
          internal_width,
          params.depth,
          params.material,
          params.thickness,
          params.edge_band,
          1
        )

        # Back panel
        @parts << PartFactory.create_panel(
          'Back Panel',
          params.width,
          params.height,
          'Plywood',
          6,
          nil,
          1
        )

        # Shelves
        shelf_count = params.shelf_count.to_i
        if shelf_count > 0
          shelf_count.times do |index|
            @parts << PartFactory.create_shelf(
              "Shelf #{index + 1}",
              internal_width,
              params.depth,
              params.material,
              params.thickness,
              1
            )
          end
        end

        # Door
        door_width = geometry.calculate_door_clearance(params.width, params.thickness, params.clearance)
        door_height = geometry.calculate_internal_height(params.height, params.thickness)

        @parts << PartFactory.create_door(
          'Door',
          door_width,
          door_height,
          params.material,
          params.thickness,
          1
        )
      end

      def calculate_shelf_positions
        internal_height = geometry.calculate_internal_height(params.height, params.thickness)
        @shelf_positions = geometry.calculate_shelf_positions(
          internal_height,
          params.shelf_count.to_i,
          params.thickness,
          params.thickness
        )
      end
    end
  end
end
