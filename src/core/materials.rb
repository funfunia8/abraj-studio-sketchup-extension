# frozen_string_literal: true

module AbrajStudio
  module Core
    class Materials
      SHEET_MATERIALS = {
        'MDF' => { density: 0.75, cost_per_sheet: 45.0, thickness_range: [6, 9, 12, 15, 18, 25] },
        'MDF Moisture Resistant' => { density: 0.8, cost_per_sheet: 65.0, thickness_range: [6, 9, 12, 15, 18, 25] },
        'HDF' => { density: 0.9, cost_per_sheet: 55.0, thickness_range: [6, 9, 12] },
        'Plywood' => { density: 0.6, cost_per_sheet: 75.0, thickness_range: [6, 9, 12, 15, 18] },
        'Melamine' => { density: 0.7, cost_per_sheet: 50.0, thickness_range: [12, 15, 18, 25] },
        'Oak' => { density: 0.75, cost_per_sheet: 120.0, thickness_range: [12, 18, 25] },
        'Walnut' => { density: 0.65, cost_per_sheet: 150.0, thickness_range: [12, 18, 25] },
        'Beech' => { density: 0.75, cost_per_sheet: 100.0, thickness_range: [12, 18, 25] }
      }.freeze

      EDGE_BANDS = {
        'PVC 2mm' => { cost: 0.5, colors: ['White', 'Black', 'Walnut', 'Oak'] },
        'ABS 2mm' => { cost: 0.75, colors: ['White', 'Black', 'Walnut', 'Oak'] },
        'Wood 2mm' => { cost: 1.5, colors: ['Walnut', 'Oak', 'Beech'] },
        'Leather' => { cost: 3.0, colors: ['Black', 'Brown', 'White'] }
      }.freeze

      HARDWARE = {
        'handles' => {
          'Recessed' => { cost: 2.0, length: 32 },
          'External Round' => { cost: 3.5, length: 64 },
          'External Straight' => { cost: 2.5, length: 96 },
          'Hidden' => { cost: 1.5, length: 0 }
        },
        'hinges' => {
          'Standard' => { cost: 1.0, soft_close: false },
          'Soft Close' => { cost: 3.5, soft_close: true },
          'Half Overlay' => { cost: 1.5, soft_close: false },
          'Soft Close Half Overlay' => { cost: 4.0, soft_close: true }
        },
        'drawer_systems' => {
          'Standard' => { cost: 5.0, soft_close: false },
          'Soft Close' => { cost: 12.0, soft_close: true },
          'Telescopic' => { cost: 8.0, soft_close: false }
        }
      }.freeze

      def self.get_material(name)
        SHEET_MATERIALS[name] || { density: 0.7, cost_per_sheet: 50.0, thickness_range: [18] }
      end

      def self.get_edge_band(name)
        EDGE_BANDS[name] || { cost: 0.5, colors: ['White'] }
      end

      def self.get_handle(name)
        HARDWARE['handles'][name] || { cost: 2.0, length: 32 }
      end

      def self.get_hinge(name)
        HARDWARE['hinges'][name] || { cost: 1.0, soft_close: false }
      end

      def self.get_drawer_system(name)
        HARDWARE['drawer_systems'][name] || { cost: 5.0, soft_close: false }
      end
    end
  end
end
