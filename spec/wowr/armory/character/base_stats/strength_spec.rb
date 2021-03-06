require 'spec_helper'

module Wowr::Armory::Character::BaseStats
  describe Strength do
    subject { Strength.new(fake_element) }

    its(:base)       { should satisfy { |v| v > 0 && v < 200 } }
    its(:effective)  { should satisfy { |v| v > 0 && v < 10000 } }
    its(:attack)     { should satisfy { |v| v > 0 && v < 10000 } }
    its(:block)      { should satisfy { |v| v > 0 && v < 2000 } }

    protected

    def fake_element
      xml = file_fixture('armory/character-sheet/alephone_mal_ganis.xml')
      (Nokogiri::XML(xml)%'baseStats'%'strength')
    end
  end
end
