# frozen_string_literal: true

module AbrajStudio
  module Core
    class GeometryEngine
      def self.calculate_internal_width(total_width, thickness)
        total_width - (2 * thickness)
      end

      def self.calculate_internal_height(total_height, thickness)
        total_height - (2 * thickness)
      end

      def self.calculate_shelf_spacing(interior_height, shelf_count, shelf_thickness)
        return 0 if shelf_count <= 0

        available_height = interior_height - (shelf_count * shelf_thickness)
        available_height / (shelf_count + 1)
      end

      def self.calculate_shelf_positions(interior_height, shelf_count, shelf_thickness, base_thickness)
        return [] if shelf_count <= 0

        spacing = calculate_shelf_spacing(interior_height, shelf_count, shelf_thickness)
        positions = []

        (1..shelf_count).each do |index|
          position = base_thickness + (spacing * index) + (shelf_thickness * (index - 1))
          positions << position
        end

        positions
      end

      def self.calculate_back_panel_width(carcass_width)
        carcass_width
      end

      def self.calculate_back_panel_height(carcass_height)
        carcass_height
      end

      def self.calculate_door_clearance(width, thickness, clearance = 2)
        width - (2 * thickness) - clearance
      end

      def self.calculate_drawer_depth(carcass_depth, thickness, clearance = 5)
        carcass_depth - thickness - clearance
      end
    end
  end
end
