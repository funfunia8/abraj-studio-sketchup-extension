# frozen_string_literal: true

module AbrajStudio
  module Reports
    class DetailedCutList
      def initialize(cabinet_spec)
        @cabinet = cabinet_spec
      end

      def generate
        parts_with_details = @cabinet.parts_list.map.with_index do |part, index|
          {
            part_number: index + 1,
            name: part[:name],
            kind: part[:kind],
            quantity: part[:quantity],
            width: part[:dimensions][:width],
            height: part[:dimensions][:height] || part[:dimensions][:depth],
            depth: part[:dimensions][:depth] || 0,
            material: part[:material],
            thickness: part[:thickness],
            edge_band: part[:edge_band],
            surface_area: calculate_surface_area(part),
            weight: calculate_weight(part),
            notes: generate_notes(part[:kind], part[:name])
          }
        end

        {
          title: 'ABRAJ STUDIO - Cut List',
          cabinet_summary: @cabinet.summary,
          total_parts: parts_with_details.length,
          parts: parts_with_details,
          generated_at: Time.now.to_s
        }
      end

      private

      def calculate_surface_area(part)
        width = part[:dimensions][:width] || 0
        height = part[:dimensions][:height] || part[:dimensions][:depth] || 0
        (width * height) / 1_000_000.0  # Convert to m²
      end

      def calculate_weight(part)
        material = AbrajStudio::Core::Materials.get_material(part[:material])
        surface_area = calculate_surface_area(part)
        thickness_m = (part[:thickness] || 18) / 1000.0
        density = material[:density] || 0.7

        (surface_area * thickness_m * density * 1000).round(2)  # kg
      end

      def generate_notes(kind, name)
        case kind
        when 'panel'
          "Standard panel - apply edge band on all edges"
        when 'shelf'
          "Shelf - drill holes for pegs at 32mm intervals"
        when 'door'
          "Door - route hinge holes, handle hole, adjust clearance"
        when 'drawer_front'
          "Drawer front - route handle hole and mounting holes"
        else
          ""
        end
      end
    end
  end
end
