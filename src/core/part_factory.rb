# frozen_string_literal: true

module AbrajStudio
  module Core
    class PartFactory
      def self.create_part(name:, kind:, dimensions:, material:, thickness:, edge_band: nil, quantity: 1)
        {
          id: SecureRandom.uuid,
          name: name,
          kind: kind,
          dimensions: dimensions,
          material: material,
          thickness: thickness,
          edge_band: edge_band,
          quantity: quantity,
          created_at: Time.now
        }
      end

      def self.create_panel(name, width, depth, material, thickness, edge_band = 'PVC 2mm', quantity = 1)
        create_part(
          name: name,
          kind: 'panel',
          dimensions: { width: width, depth: depth },
          material: material,
          thickness: thickness,
          edge_band: edge_band,
          quantity: quantity
        )
      end

      def self.create_shelf(name, width, depth, material, thickness, quantity = 1)
        create_part(
          name: name,
          kind: 'shelf',
          dimensions: { width: width, depth: depth },
          material: material,
          thickness: thickness,
          quantity: quantity
        )
      end

      def self.create_door(name, width, height, material, thickness, quantity = 1)
        create_part(
          name: name,
          kind: 'door',
          dimensions: { width: width, height: height },
          material: material,
          thickness: thickness,
          quantity: quantity
        )
      end

      def self.create_drawer_front(name, width, height, material, thickness, quantity = 1)
        create_part(
          name: name,
          kind: 'drawer_front',
          dimensions: { width: width, height: height },
          material: material,
          thickness: thickness,
          quantity: quantity
        )
      end
    end
  end
end
