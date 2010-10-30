require 'bundler'
Bundler.setup
Bundler::GemHelper.install_tasks

require 'rake/testtask'
require 'rspec/core/rake_task'
require 'cucumber/rake/task'

$:.unshift(File.expand_path('../lib', __FILE__))

desc 'Default: run specs.'
task :default => :spec

desc "Run specs"
RSpec::Core::RakeTask.new do |t|
  t.pattern = "./spec/**/*_spec.rb"
end

desc "Generate aggregate code coverage"
task :coverage do
  rm_f "coverage"
  rm_f "coverage.data"
  Rake::Task["coverage:rspec"].invoke
  Rake::Task["coverage:cucumber"].invoke
end

namespace :coverage do
  desc "Generate code coverage for RSpec tests"
  RSpec::Core::RakeTask.new(:rspec) do |t|
    t.pattern = "./spec/**/*_spec.rb"
    t.rcov = true
    t.rcov_opts = %w{--exclude gems\/,spec\/,features\/ --sort coverage --aggregate coverage.data --text-report}
  end

  desc "Generate code coverage for Cucmber tests"
  Cucumber::Rake::Task.new(:cucumber) do |t|
    t.rcov = true
    t.rcov_opts = %w{--exclude gems\/,spec\/,features\/ --sort coverage --aggregate coverage.data}
  end
end

# TODO: remove Rake::TestTask :test once tests have been converted and functionality has been confirmed with Specs
# bundle exec rcov -Ilib -t test/**/*.rb --exclude gems/ -o coverage_test
desc "Run tests"
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

namespace :whitespace do
  FIND_FILE_BLACKLIST = "find . -type f | grep -v -e '.git/' -e 'coverage/' -e 'pkg/' -e 'vendor/' -e '.data' -e '.DS_Store'"

  desc 'Runs all whitespace tasks'
  task :all do
    Rake::Task["whitespace:remove_trailing"].invoke
    Rake::Task["whitespace:covert_to_soft_tabs"].invoke
    Rake::Task["whitespace:remove_blank_lines"].invoke
  end

  desc 'Removes trailing whitespace'
  task :remove_trailing do
    system %{
      echo Removing trailing whitespace
      for f  in `#{FIND_FILE_BLACKLIST}`;
        do cat $f | sed 's/[ \t]*$//' > .whitespace; cp .whitespace $f; rm .whitespace; echo $f;
      done
    }
  end

  desc 'Converts hard-tabs into two-space soft-tabs'
  task :covert_to_soft_tabs do
    system %{
      echo Converting hard-tabs into two-space soft-tabs
      for f in `#{FIND_FILE_BLACKLIST}`;
        do cat $f | sed 's/\t/  /g' > .soft_tabs; cp .soft_tabs $f; rm .soft_tabs; echo $f;
      done
    }
  end

  desc 'Remove consecutive blank lines'
  task :remove_blank_lines do
    system %{
      echo Removing consecutive blank lines
      for f in `#{FIND_FILE_BLACKLIST}`;
        do cat $f | sed '/./,/^$/!d' > .blank_lines; cp .blank_lines $f; rm .blank_lines; echo $f;
      done
    }
  end
end

namespace :file_fixtures do
  def download_file(remote, local)
    `curl -s -A "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.10) Gecko/20100914 Firefox/3.6.10" -o "#{local}" "#{remote}"`
  end

  def fixtures
    # key is the folder relative to spec/file_fixtures/armory/, value is an array of hashes:
    #   r: remote path after "wowarmory.com/file.xml?"
    #   l: local filename without extension
    {
      'character-achievements' => [
        {:r => "r=Mal'Ganis&cn=Sebudai",      :l => 'sebudai_mal_ganis'}
      ],
      'character-reputation' => [
        {:r => "r=Mal'Ganis&cn=DoesNotExist", :l => 'not_found'},
        {:r => "r=Mal'Ganis&cn=Sebudai",      :l => 'sebudai_mal_ganis'}
      ],
      'character-sheet' => [
        {:r => "r=Mal'Ganis&cn=DoesNotExist", :l => 'not_found'},
        {:r => "r=Mal'Ganis&cn=Sebudai",      :l => 'sebudai_mal_ganis'}
      ],
      'character-talents' => [
        {:r => "r=Mal'Ganis&cn=DoesNotExist", :l => 'not_found'},
        {:r => "r=Mal'Ganis&cn=Sebudai",      :l => 'sebudai_mal_ganis'}
      ],
      'guild-info' => [
        {:r => "r=Mal'Ganis&gn=DoesNotExist", :l => 'not_found'},
        {:r => "r=Mal'Ganis&gn=Juggernaut",   :l => 'juggernaut_mal_ganis'}
      ],
      'item-info' => [
        {:r => "i=40395", :l => '40395'},
        {:r => "i=0",     :l => 'not_found'}
      ],
      'item-tooltip' => [
        {:r => "i=40395", :l => '40395'},
        {:r => "i=0",     :l => 'not_found'},
        {:r => "i=46017", :l => '46017'},
        {:r => "i=16922", :l => '16922'},
        {:r => "i=50727", :l => '50727'},
        {:r => "i=40111", :l => '40111'}
      ],
      'search' => [
        {:r => "searchQuery=Lemon&searchType=arenateams",   :l => 'arena_teams_lemon'},
        {:r => "searchQuery=Sebudai&searchType=characters", :l => 'characters_sebudai'},
        {:r => "searchQuery=Juggernaut&searchType=guilds",  :l => 'guilds_juggernaut'},
        {:r => "searchQuery=Cake&searchType=items",         :l => 'items_cake'}
      ],
      'team-info' => [
        {:r => "r=Mal'Ganis&ts=5&t=Fav+Five",     :l => 'fav_five_mal_ganis'},
        {:r => "r=Mal'Ganis&ts=5&t=DoesNotExist", :l => 'not_found'}
      ]
    }
  end

  desc "Download only missing file fixtures"
  task :download do
    fixtures.each do |folder, hashes|
      hashes.each do |hash|
        remote = "http://www.wowarmory.com/#{folder}.xml?#{hash[:r]}"
        local  = "spec/file_fixtures/armory/#{folder}/#{hash[:l]}.xml"

        unless File.exists? File.expand_path("../#{local}", __FILE__)
          puts "#{remote.ljust(80)} -> #{local}"
          download_file(remote, File.expand_path("../#{local}", __FILE__))
        end
      end
    end

    puts ""
    system "git status -s"
  end

  desc "Update all file fixtures"
  task :update do
    fixtures.each do |folder, hashes|
      hashes.each do |hash|
        remote = "http://www.wowarmory.com/#{folder}.xml?#{hash[:r]}"
        local  = "spec/file_fixtures/armory/#{folder}/#{hash[:l]}.xml"
        puts "#{remote.ljust(80)} -> #{local}"
        download_file(remote, File.expand_path("../#{local}", __FILE__))
      end
    end

    puts ""
    system "git status -s"
  end
end
