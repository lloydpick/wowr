require 'spec_helper'

module Wowr::Armory::Character::BaseStats
  describe Spirit do
    subject { Spirit.new(fake_element) }

    its(:base)          { should satisfy { |v| v > 0 && v < 300} }
    its(:effective)     { should satisfy { |v| v > 0 && v < 300 } }
    its(:health_regen)  { should satisfy { |v| v > 0 } }
    its(:mana_regen)    { should satisfy { |v| v > 0 } }

    protected

    def fake_element
      xml = file_fixture('armory/character-sheet/fearsom_mal_ganis.xml')
      (Nokogiri::XML(xml)%'baseStats'%'spirit')
    end
  end
end
