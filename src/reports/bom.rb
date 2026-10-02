# frozen_string_literal: true

module AbrajStudio
  module Reports
    class Bom
      def initialize(cabinet)
        @cabinet = cabinet
      end

      def generate
        [
          { name: 'Sheet Material', item: @cabinet.params.material, quantity: 2, unit: 'sheet' },
          { name: 'Edge Band', item: @cabinet.params.edge_band, quantity: 1, unit: 'roll' },
          { name: 'Soft Close Hinge', item: @cabinet.params.hinge_type, quantity: 2, unit: 'pcs' },
          { name: 'Handle', item: @cabinet.params.handle_type, quantity: 1, unit: 'pcs' },
          { name: 'Fasteners', item: 'Screws + Dowels', quantity: 1, unit: 'set' }
        ]
      end
    end
  end
end
