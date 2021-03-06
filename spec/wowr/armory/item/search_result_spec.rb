require 'spec_helper'

module Wowr::Armory::Item
  describe SearchResult do
    subject { SearchResult.new(fake_element) }

    its(:url)         { should eql("i=45218") }
    its(:quality)     { should eql(3) }
    its(:source)      { should eql('sourceType.vendor') }
    its(:item_level)  { should eql(200) }
    its(:relevance)   { should satisfy { |n| n > 0 && n <= 100 } }

    # Aliased methods
    its(:level) { should eql(200) }
    its(:rarity) { should eql(3) }

    protected

    def fake_element
      xml = file_fixture('armory/search/items_cake.xml')
      (Nokogiri::XML(xml)%'items'/'item')[0]
    end
  end
end
