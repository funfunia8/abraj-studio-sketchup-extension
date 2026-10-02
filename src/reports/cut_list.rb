# frozen_string_literal: true

module AbrajStudio
  module Reports
    class CutList
      def initialize(cabinet)
        @cabinet = cabinet
      end

      def generate
        @cabinet.parts.map do |part|
          {
            part: part[:name],
            quantity: part[:quantity],
            kind: part[:kind],
            x: part[:x],
            y: part[:y],
            material: part[:material],
            thickness: part[:thickness],
            edge_band: part[:edge_band]
          }
        end
      end
    end
  end
end
