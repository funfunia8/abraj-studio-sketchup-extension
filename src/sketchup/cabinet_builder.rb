# frozen_string_literal: true

module AbrajStudio
  module SketchUp
    class CabinetBuilder
      def initialize(params)
        @params = params
      end

      def build
        {
          type: 'Base Cabinet',
          width: @params.width,
          height: @params.height,
          depth: @params.depth,
          material: @params.material,
          thickness: @params.thickness,
          shell: build_shell,
          shelves: build_shelves,
          door: build_door
        }
      end

      private

      def build_shell
        {
          left_side: { width: @params.height, height: @params.depth },
          right_side: { width: @params.height, height: @params.depth },
          top: { width: @params.width, depth: @params.depth },
          bottom: { width: @params.width, depth: @params.depth },
          back: { width: @params.width, height: @params.height }
        }
      end

      def build_shelves
        count = @params.shelf_count.to_i
        Array.new(count) do |index|
          {
            name: "Shelf #{index + 1}",
            width: @params.width,
            depth: @params.depth,
            thickness: @params.thickness
          }
        end
      end

      def build_door
        {
          type: @params.door_type,
          width: @params.width,
          height: @params.height,
          material: @params.material
        }
      end
    end
  end
end
