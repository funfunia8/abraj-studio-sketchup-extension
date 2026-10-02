# frozen_string_literal: true

module AbrajStudio
  module SketchUp
    class ModelGenerator
      def initialize(cabinet_spec)
        @cabinet = cabinet_spec
      end

      def generate_3d_model_data
        {
          model_name: 'Base Cabinet',
          entities: generate_entities,
          groups: generate_groups,
          materials: assign_materials
        }
      end

      private

      def generate_entities
        entities = []

        # Left side
        entities << create_box(
          'Left Side',
          0,
          0,
          0,
          @cabinet.params.thickness,
          @cabinet.params.height,
          @cabinet.params.depth
        )

        # Right side
        entities << create_box(
          'Right Side',
          @cabinet.params.width - @cabinet.params.thickness,
          0,
          0,
          @cabinet.params.thickness,
          @cabinet.params.height,
          @cabinet.params.depth
        )

        # Top panel
        entities << create_box(
          'Top Panel',
          @cabinet.params.thickness,
          @cabinet.params.height - @cabinet.params.thickness,
          0,
          @cabinet.params.width - (2 * @cabinet.params.thickness),
          @cabinet.params.thickness,
          @cabinet.params.depth
        )

        # Bottom panel
        entities << create_box(
          'Bottom Panel',
          @cabinet.params.thickness,
          0,
          0,
          @cabinet.params.width - (2 * @cabinet.params.thickness),
          @cabinet.params.thickness,
          @cabinet.params.depth
        )

        # Shelves
        @cabinet.shelf_positions.each_with_index do |y_pos, index|
          entities << create_box(
            "Shelf #{index + 1}",
            @cabinet.params.thickness,
            y_pos,
            0,
            @cabinet.params.width - (2 * @cabinet.params.thickness),
            @cabinet.params.thickness,
            @cabinet.params.depth
          )
        end

        # Door
        door_width = @cabinet.params.width - (2 * @cabinet.params.thickness) - @cabinet.params.clearance
        door_height = @cabinet.params.height - (2 * @cabinet.params.thickness)

        entities << create_box(
          'Door',
          (@cabinet.params.width - door_width) / 2,
          @cabinet.params.thickness,
          @cabinet.params.depth + 5,
          door_width,
          door_height,
          @cabinet.params.thickness
        )

        entities
      end

      def create_box(name, x, y, z, width, height, depth)
        {
          name: name,
          type: 'box',
          position: { x: x, y: y, z: z },
          dimensions: { width: width, height: height, depth: depth }
        }
      end

      def generate_groups
        {
          'Shell' => ['Left Side', 'Right Side', 'Top Panel', 'Bottom Panel'],
          'Interior' => ['Shelf 1', 'Shelf 2', 'Shelf 3'],
          'Hardware' => ['Door']
        }
      end

      def assign_materials
        {
          'Left Side' => @cabinet.params.material,
          'Right Side' => @cabinet.params.material,
          'Top Panel' => @cabinet.params.material,
          'Bottom Panel' => @cabinet.params.material,
          'Door' => @cabinet.params.material
        }
      end
    end
  end
end
