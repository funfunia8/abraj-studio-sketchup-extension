# frozen_string_literal: true

module AbrajStudio
  module Reports
    class DetailedBom
      def initialize(cabinet_spec)
        @cabinet = cabinet_spec
      end

      def generate
        materials_summary = aggregate_materials
        hardware_summary = aggregate_hardware
        accessories_summary = aggregate_accessories

        {
          title: 'ABRAJ STUDIO - Bill of Materials',
          cabinet_summary: @cabinet.summary,
          materials: materials_summary,
          hardware: hardware_summary,
          accessories: accessories_summary,
          totals: calculate_totals(materials_summary, hardware_summary, accessories_summary),
          generated_at: Time.now.to_s
        }
      end

      private

      def aggregate_materials
        materials = {}

        @cabinet.parts_list.each do |part|
          material_name = part[:material]
          thickness = part[:thickness]
          surface_area = (part[:dimensions][:width] * part[:dimensions][:height] || part[:dimensions][:depth]) / 1_000_000.0

          key = "#{material_name} (#{thickness}mm)"

          if materials[key]
            materials[key][:quantity] += part[:quantity]
            materials[key][:total_area] += surface_area * part[:quantity]
          else
            material_info = AbrajStudio::Core::Materials.get_material(material_name)
            materials[key] = {
              material: material_name,
              thickness: thickness,
              quantity: part[:quantity],
              total_area: surface_area * part[:quantity],
              unit_cost: material_info[:cost_per_sheet],
              total_cost: material_info[:cost_per_sheet] * part[:quantity]
            }
          end
        end

        materials.map { |_key, value| value }
      end

      def aggregate_hardware
        hardware_list = []

        # Hinges
        hinge_info = AbrajStudio::Core::Materials.get_hinge(@cabinet.params.hinge_type)
        hardware_list << {
          type: 'Hinge',
          description: @cabinet.params.hinge_type,
          quantity: 2,
          unit_cost: hinge_info[:cost],
          total_cost: 2 * hinge_info[:cost],
          soft_close: hinge_info[:soft_close]
        }

        # Handle
        handle_info = AbrajStudio::Core::Materials.get_handle(@cabinet.params.handle_type)
        hardware_list << {
          type: 'Handle',
          description: @cabinet.params.handle_type,
          quantity: 1,
          unit_cost: handle_info[:cost],
          total_cost: handle_info[:cost],
          length: handle_info[:length]
        }

        # Fasteners
        hardware_list << {
          type: 'Fasteners',
          description: 'Screws + Dowels Kit',
          quantity: 1,
          unit_cost: 15.0,
          total_cost: 15.0,
          includes: 'Wood screws, dowels, pocket hole screws'
        }

        hardware_list
      end

      def aggregate_accessories
        accessories = []

        # Edge band
        edge_band_info = AbrajStudio::Core::Materials.get_edge_band(@cabinet.params.edge_band)
        edged_parts = @cabinet.parts_list.select { |p| p[:edge_band].present? }
        total_edge_length = edged_parts.sum { |p| (p[:dimensions][:width] + p[:dimensions][:height] || p[:dimensions][:depth]) * p[:quantity] } / 1000.0

        accessories << {
          type: 'Edge Band',
          description: @cabinet.params.edge_band,
          quantity: total_edge_length,
          unit: 'meters',
          unit_cost: edge_band_info[:cost],
          total_cost: (total_edge_length * edge_band_info[:cost]).round(2)
        }

        # Shelf pegs (if shelves exist)
        if @cabinet.params.shelf_count.to_i > 0
          shelf_pegs_quantity = @cabinet.params.shelf_count.to_i * 4
          accessories << {
            type: 'Shelf Pegs',
            description: 'Dowel pegs for shelf support',
            quantity: shelf_pegs_quantity,
            unit: 'pieces',
            unit_cost: 0.2,
            total_cost: (shelf_pegs_quantity * 0.2).round(2)
          }
        end

        accessories
      end

      def calculate_totals(materials, hardware, accessories)
        materials_total = materials.sum { |m| m[:total_cost] || 0 }
        hardware_total = hardware.sum { |h| h[:total_cost] || 0 }
        accessories_total = accessories.sum { |a| a[:total_cost] || 0 }
        grand_total = materials_total + hardware_total + accessories_total

        {
          materials_cost: materials_total.round(2),
          hardware_cost: hardware_total.round(2),
          accessories_cost: accessories_total.round(2),
          material_subtotal: materials_total.round(2),
          grand_total: grand_total.round(2),
          waste_factor: 0.1,
          total_with_waste: (grand_total * 1.1).round(2)
        }
      end
    end
  end
end
