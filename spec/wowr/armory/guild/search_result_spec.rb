require 'spec_helper'

module Wowr::Armory::Guild
  describe SearchResult do
    subject { SearchResult.new(fake_element) }

    its(:faction)      { should eql("Horde") }
    its(:faction_id)   { should eql(1) }
    its(:battle_group) { should eql("Stormstrike") }
    its(:relevance)    { should satisfy { |n| n > 0 && n <= 100 } }

    its(:class) { should superclass(Wowr::Armory::Guild::Base) }

    protected

    def fake_element
      xml = file_fixture('armory/search/guilds_juggernaut.xml')
      (Nokogiri::XML(xml).search(%{guild[@realm$="Ganis"]})[0])
    end
  end
end
