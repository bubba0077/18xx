# frozen_string_literal: true

require 'view/hex'
require 'view/tile_confirmation'
require 'view/tile_selector'

require 'engine/hex'

module View
  class Map < Snabberb::Component
    needs :game
    needs :selected_hex_info, default: nil, store: true

    def render
      hexes = @game.map.hexes.dup
      # move the selected hex to the back so it renders highest in z space
      hexes << hexes.delete(@selected_hex_info[:hex]) if @selected_hex_info
      hexes.map! { |hex| h(Hex, hex: hex, game: @game) }

      children = [
        h(:svg, { style: { width: '100%', height: '800px' } }, [
          h(:g, { attrs: { transform: 'scale(0.5)' } }, hexes)
        ]),
      ]

      if @selected_hex_info
        children << h(TileSelector) unless @selected_hex_info[:tile]
        children << h(TileConfirmation) if @selected_hex_info[:tile]
      end

      h(:div, children)
    end
  end
end
