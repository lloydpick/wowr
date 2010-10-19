require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper'))

class WowrTest < Test::Unit::TestCase

  def setup
    @api_empty = Wowr::API.new
    @api_set = Wowr::API.new(:character_name => 'Clublife', :realm => "Barthilas", :guild_name => "Cake")
    @api_no_cache = Wowr::API.new(:caching => false)
  end

  def teardown
    @api_set.clear_cache
    FileUtils.rm_rf(SAVE_PATH)
  end

  def test_no_server
    api = Wowr::API.new(:locale => 'hoge')

    assert_raises Wowr::Exceptions::ServerDoesNotExist do
      api.search_characters(:search => 'cake')
    end
  end

  def test_searching
    assert_not_nil @api_empty.search_characters("cake")
    assert_not_nil @api_empty.search_items("cake")
    assert_not_nil @api_empty.search_guilds("cake")
    assert_not_nil @api_empty.search_arena_teams("cake")

    # Some results found
    assert_not_equal @api_empty.search_characters("cake"), []
    assert_not_equal @api_empty.search_items("cake"), []
    assert_not_equal @api_empty.search_guilds("cake"), []
    assert_not_equal @api_empty.search_arena_teams("cake"), []

    assert_raises ArgumentError do
      @api_empty.search_characters
    end

    assert_raises ArgumentError do
      @api_empty.search_items
    end

    assert_raises ArgumentError do
      @api_empty.search_guilds
    end

    assert_raises ArgumentError do
      @api_empty.search_arena_teams
    end
  end

  # ensure that the requested language is being returned
  def test_languages
    language = 'fr_fr'
    api = Wowr::API.new(:lang => language)

    returned_language = 'fr_fr'

    assert_equal language, returned_language
  end

  def test_caching

  end

  # def test_bad_xml
  #   Wowr::API.character_sheet_url = XML_BASE + 'bad_character.xml'
  #   skill = @api.skill_in_training
  #   assert_not_nil @api.last_hash
  # end
  #
  # def test_item
  #
  # end
  #

  def test_item_api_references

  end
  #
  #
  # def test_character_sheet
  #   Wowr::API.character_sheet_url = XML_BASE + 'character-sheet.xml'
  #   #Reve::API.conqurable_outposts_url = XML_BASE + 'conqurable_stations.xml'
  #   character = nil
  #   assert_nothing_raised do
  #     character = @api.get_character_sheet
  #   end
  #
  #   assert_not_nil character.title
  #   assert_not_nil character.health
  #
  #   test_second_bar(character.second_bar)
  #
  #   assert_instance_of Wowr::Classes::Strength, character.strength
  #
  #   test_strength(character.strength)
  #   test_agility(character.agility)
  #   test_stamina(character.stamina)
  #   test_intellect(character.intellect)
  #   test_spirit(character.spirit)
  #
  #   test_melee(character.melee)
  #   test_ranged(character.ranged)
  #   test_spell(character.spell)
  #   test_defenses(character.defenses)
  #
  #   character.professions do |prof|
  #     test_professions(prof)
  #   end
  #
  #   character.items do |item|
  #     test_equipped_item(item)
  #   end
  #
  #   character.buffs do |buff|
  #     test_buffs_debuffs(buff)
  #   end
  #
  #   character.debuffs do |debuff|
  #     test_buffs_debuffs(debuff)
  #   end
  # end
  #
  # def test_second_bar
  #
  # end
  #
  # def test_strength(strength)
  #   attrs = ["base", "effective", "attack", "block"]
  #
  #   attrs do |att|
  #     assert_not_nil strength.att
  #   end
  # end
  #
  # def test_agility
  #
  # end
  #
  # def test_stamina
  #
  # end
  #
  # def test_intellect
  #
  # end
  #
  # def test_spirit
  #
  # end
  #
  # def test_melee
  #
  # end
  #
  # def test_ranged
  #
  # end
  #
  # def test_spell
  #
  # end
  #
  # def test_defenses
  #
  # end
  #
  # def test_profession
  #
  # end
  #
  # def test_equipped_item
  #
  # end
  #     # # TODO: Massive problem, doesn't fill in resistances for some reason
  #     # resist_types = ['arcane', 'fire', 'frost', 'holy', 'nature', 'shadow']
  #     # @resistances = {}
  #     # resist_types.each do |res|
  #     #   @resistances[res] = Resistance.new(elem%'resistances'%res)
  #     # end
  #     #
  #     # @talent_spec = TalentSpec.new(elem%'talentSpec')
  #     #
  #     # @pvp = Pvp.new(elem%'pvp')
  #
  #
  # def test_buffs_debuffs
  #
  # end

  # def test_skill_tree_clean
  #   Reve::API.skill_tree_url = XML_BASE + 'skilltree.xml'
  #   skilltrees = nil
  #   assert_nothing_raised do
  #     skilltrees = @api.skill_tree
  #   end
  #   assert_not_nil @api.last_hash
  #   assert_not_nil @api.cached_until
  #   assert_equal 2, skilltrees.size
  #   skilltrees.each do |skill|
  #     assert_not_nil skill.type_id
  #     assert_not_nil skill.name
  #     assert_not_nil skill.rank
  #     assert_not_nil skill.description
  #     skill.bonuses.each do |bonus|
  #       assert_kind_of Reve::Classes::SkillBonus, bonus
  #     end
  #     skill.attribs.each do |attrib|
  #       assert_kind_of Reve::Classes::RequiredAttribute, attrib
  #     end
  #     skill.required_skills.each do |req|
  #       assert_kind_of Reve::Classes::SkillRequirement, req
  #     end
  #   end
  # end
  #
  def test_cache_timeout
    api = Wowr::API.new(:character_name => 'Cake', :realm => "Barthilas", :guild_name => "Cake", :debug => true, :caching => true)
    # api = Wowr::API.new(:character_name => 'Sonny', :realm => "Arena Tournament 1", :locale => 'eu', :debug => true, :caching => false)
    # api = Wowr::API.new(:realm => "Trollbane", :guild_name => "Rawr", :locale => 'eu', :debug => true, :caching => true)
    # api.default_cache_timeout = 10

    # char = api.get_character

    # path defaults_api.cache_path(url)
    #
    # if File.exists?(path) ||
    #     options[:refresh_cache] ||
    #     (File.mtime(path) < Time.now - @cache_timeout)

  end

  def test_money
    no_gold_silver = Wowr::Classes::Money.new(43)
    assert_equal no_gold_silver.gold, 0
    assert_equal no_gold_silver.silver, 0
    assert_equal no_gold_silver.bronze, 43
    assert_equal no_gold_silver.total, 43

    money = Wowr::Classes::Money.new(5552243)
    assert_equal money.gold, 555
    assert_equal money.silver, 22
    assert_equal money.bronze, 43
    assert_equal money.total, 5552243

    assert_equal (money + no_gold_silver).total, 5552286
    assert_equal (money - no_gold_silver).total, 5552200
  end

  def test_assignment
    assert_nothing_raised do
      temp = Wowr::API.search_url
      Wowr::API.search_url = "test"
      Wowr::API.search_url = temp

      temp = Wowr::API.cache_directory_path
      Wowr::API.cache_directory_path = "hello/"
      Wowr::API.cache_directory_path = temp
    end
  end

end

# require 'wowr_character_test.rb'
# require 'wowr_guild_test.rb'
# require 'wowr_item_test.rb'
# require 'wowr_arena_team_test.rb'
# require 'wowr_dungeon_test.rb'
