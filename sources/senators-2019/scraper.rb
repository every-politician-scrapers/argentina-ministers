#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class String
  def ztidy
    gsub(/[\u200B-\u200D\uFEFF]/, '').tidy
  end
end

class DmyDate
  def initialize(datestr)
    @datestr = datestr
  end

  def to_s
    return if datestr.include? 'En el cargo'

    datestr.split('/').map(&:ztidy).reverse.map { |str| format('%02d', str.to_i) }.join('-')
  end

  attr_reader :datestr
end

class RepList < Scraped::HTML
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  field :members do
    member_entries.map { |ul| fragment(ul => Rep) }.reject(&:empty?).map(&:to_h)
  end

  private

  def member_entries
    noko.xpath('//table[.//th[contains(., "Mandato")]][last()]//tr[td]')
  end

  class Rep < Scraped::HTML
    def empty?
      noko.text.to_s.empty?
    end

    field :item do
      name_node.attr('wikidata')
    end

    field :name do
      name_node.text.ztidy
    end

    field :region do
      region_node.attr('wikidata')
    end

    field :regionLabel do
      region_node.text.ztidy
    end

    field :party do
      party_node.attr('wikidata')
    end

    field :partyLabel do
      party_node.text.ztidy
    end

    field :startDate do
      DmyDate.new(tds[7].text.tidy).to_s
    end

    field :endDate do
      DmyDate.new(tds[8].text.tidy).to_s
    end

    private

    def tds
      noko.css('td')
    end

    def region_node
      tds[0].css('a').last
    end

    def party_node
      tds[4].css('a')
    end

    def name_node
      tds[2].css('a') rescue binding.pry
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: RepList).csv
