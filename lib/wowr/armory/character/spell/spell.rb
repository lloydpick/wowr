module Wowr
  module Armory
    module Character
      module Spell
        # = Spell
        #
        # Represents a <tt>spell</tt> element in <tt>character-sheet.xml</tt>
        #
        # == Relevant XML example:
        #
        #   <spell>
        #     <bonusDamage>
        #       <arcane value="3751"/>
        #       <fire value="3751"/>
        #       <frost value="3751"/>
        #       <holy value="3751"/>
        #       <nature value="3751"/>
        #       <shadow value="3751"/>
        #       <petBonus attack="2138" damage="563" fromType="fire"/>
        #     </bonusDamage>
        #     <bonusHealing value="3571"/>
        #     <hitRating increasedHitPercent="17.00" penetration="0" reducedResist="0" value="446"/>
        #     <critChance rating="530">
        #       <arcane percent="26.34"/>
        #       <fire percent="26.34"/>
        #       <frost percent="26.34"/>
        #       <holy percent="26.34"/>
        #       <nature percent="26.34"/>
        #       <shadow percent="26.34"/>
        #     </critChance>
        #     <penetration value="0"/>
        #     <manaRegen casting="193.00" notCasting="364.00"/>
        #     <hasteRating hastePercent="43.37" hasteRating="1422"/>
        #   </spell>
        class Spell
          # @return [Damage] Arcane damage and crit
          attr_reader :arcane

          # @return [Damage] Fire damage and crit
          attr_reader :fire

          # @return [Damage] Frost damage and crit
          attr_reader :frost

          # @return [Damage] Holy damage and crit
          attr_reader :holy

          # @return [Damage] Nature damage and crit
          attr_reader :nature

          # @return [Damage] Shadow damage and crit
          attr_reader :shadow

          # @return [HitRating]
          attr_reader :hit_rating

          # @return [Integer]
          attr_reader :bonus_healing

          # @return [Integer]
          attr_reader :penetration

          # @return [ManaRegen]
          attr_reader :mana_regen

          # Haste
          # @return [Speed]
          attr_reader :speed

          # @param [Hpricot::Elem] elem <tt>spell</tt> element
          def initialize(elem)
            @arcane = Wowr::Classes::SpellDamage.new(elem%'bonusDamage'%'arcane', elem%'critChance'%'arcane')
            @fire   = Wowr::Classes::SpellDamage.new(elem%'bonusDamage'%'fire',   elem%'critChance'%'fire')
            @frost  = Wowr::Classes::SpellDamage.new(elem%'bonusDamage'%'frost',  elem%'critChance'%'frost')
            @holy   = Wowr::Classes::SpellDamage.new(elem%'bonusDamage'%'holy',   elem%'critChance'%'holy')
            @nature = Wowr::Classes::SpellDamage.new(elem%'bonusDamage'%'nature', elem%'critChance'%'nature')
            @shadow = Wowr::Classes::SpellDamage.new(elem%'bonusDamage'%'shadow', elem%'critChance'%'shadow')

            @bonus_healing = (elem%'bonusHealing')[:value].to_i
            @penetration   = (elem%'penetration')[:value].to_i
            @hit_rating    = HitRating.new(elem%'hitRating')
            @mana_regen    = Wowr::Classes::ManaRegen.new(elem%'manaRegen')
            @speed         = Wowr::Classes::SpellSpeed.new(elem%'hasteRating')
          end
        end
      end
    end
  end
end
