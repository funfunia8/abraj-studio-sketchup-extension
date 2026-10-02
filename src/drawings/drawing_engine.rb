# frozen_string_literal: true

module AbrajStudio
  module Drawings
    class DrawingEngine
      def initialize(cabinet_spec)
        @cabinet = cabinet_spec
      end

      def generate_front_elevation
        {
          view_type: 'Front Elevation',
          width: @cabinet.params.width,
          height: @cabinet.params.height,
          elements: [
            draw_cabinet_outline,
            draw_door,
            draw_handle,
            draw_dimensions_horizontal,
            draw_dimensions_vertical
          ]
        }
      end

      def generate_side_elevation
        {
          view_type: 'Side Elevation',
          depth: @cabinet.params.depth,
          height: @cabinet.params.height,
          elements: [
            draw_side_outline,
            draw_shelf_profile,
            draw_dimensions_depth,
            draw_dimensions_vertical
          ]
        }
      end

      def generate_plan_view
        {
          view_type: 'Plan View',
          width: @cabinet.params.width,
          depth: @cabinet.params.depth,
          elements: [
            draw_plan_outline,
            draw_shelf_positions_plan,
            draw_dimensions_plan
          ]
        }
      end

      def generate_section_view
        {
          view_type: 'Vertical Section',
          width: @cabinet.params.width,
          height: @cabinet.params.height,
          elements: [
            draw_section_outline,
            draw_shelves_section,
            draw_dimensions_section
          ]
        }
      end

      private

      def draw_cabinet_outline
        {
          type: 'rectangle',
          x: 0,
          y: 0,
          width: @cabinet.params.width,
          height: @cabinet.params.height,
          line_weight: 0.5
        }
      end

      def draw_door
        {
          type: 'rectangle',
          x: @cabinet.params.thickness,
          y: @cabinet.params.thickness,
          width: @cabinet.params.width - (2 * @cabinet.params.thickness),
          height: @cabinet.params.height - (2 * @cabinet.params.thickness),
          line_weight: 0.3,
          line_style: 'dashed'
        }
      end

      def draw_handle
        handle_y = @cabinet.params.height / 2
        {
          type: 'line',
          x1: @cabinet.params.width / 2 - 20,
          y1: handle_y,
          x2: @cabinet.params.width / 2 + 20,
          y2: handle_y,
          line_weight: 0.2
        }
      end

      def draw_dimensions_horizontal
        {
          type: 'dimension',
          dimension_type: 'horizontal',
          value: @cabinet.params.width,
          unit: 'mm',
          position_y: -50
        }
      end

      def draw_dimensions_vertical
        {
          type: 'dimension',
          dimension_type: 'vertical',
          value: @cabinet.params.height,
          unit: 'mm',
          position_x: -50
        }
      end

      def draw_side_outline
        {
          type: 'rectangle',
          x: 0,
          y: 0,
          width: @cabinet.params.depth,
          height: @cabinet.params.height,
          line_weight: 0.5
        }
      end

      def draw_shelf_profile
        shelf_positions = @cabinet.shelf_positions
        shelf_positions.map do |y_pos|
          {
            type: 'line',
            x1: 0,
            y1: y_pos,
            x2: @cabinet.params.depth,
            y2: y_pos,
            line_weight: 0.3
          }
        end
      end

      def draw_dimensions_depth
        {
          type: 'dimension',
          dimension_type: 'horizontal',
          value: @cabinet.params.depth,
          unit: 'mm',
          position_y: -50
        }
      end

      def draw_plan_outline
        {
          type: 'rectangle',
          x: 0,
          y: 0,
          width: @cabinet.params.width,
          height: @cabinet.params.depth,
          line_weight: 0.5
        }
      end

      def draw_shelf_positions_plan
        shelf_positions = @cabinet.shelf_positions
        shelf_positions.map do |y_pos|
          {
            type: 'rectangle',
            x: @cabinet.params.thickness,
            y: y_pos,
            width: @cabinet.params.width - (2 * @cabinet.params.thickness),
            height: @cabinet.params.thickness,
            line_weight: 0.2,
            fill: 'light_gray'
          }
        end
      end

      def draw_dimensions_plan
        [
          {
            type: 'dimension',
            dimension_type: 'horizontal',
            value: @cabinet.params.width,
            unit: 'mm',
            position_y: -50
          },
          {
            type: 'dimension',
            dimension_type: 'vertical',
            value: @cabinet.params.depth,
            unit: 'mm',
            position_x: -50
          }
        ]
      end

      def draw_section_outline
        {
          type: 'rectangle',
          x: 0,
          y: 0,
          width: @cabinet.params.width,
          height: @cabinet.params.height,
          line_weight: 0.5
        }
      end

      def draw_shelves_section
        shelf_positions = @cabinet.shelf_positions
        shelf_positions.map do |y_pos|
          {
            type: 'rectangle',
            x: @cabinet.params.thickness,
            y: y_pos,
            width: @cabinet.params.width - (2 * @cabinet.params.thickness),
            height: @cabinet.params.thickness,
            fill: 'hatched'
          }
        end
      end

      def draw_dimensions_section
        [
          {
            type: 'dimension',
            dimension_type: 'horizontal',
            value: @cabinet.params.width,
            unit: 'mm',
            position_y: -50
          },
          {
            type: 'dimension',
            dimension_type: 'vertical',
            value: @cabinet.params.height,
            unit: 'mm',
            position_x: -50
          }
        ]
      end
    end
  end
end
