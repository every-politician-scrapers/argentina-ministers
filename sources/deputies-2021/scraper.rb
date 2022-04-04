#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

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
      name_node.text
    end

    field :region do
      region_node.attr('wikidata')
    end

    field :regionLabel do
      region_node.text
    end

    field :party do
      party_node.attr('wikidata')
    end

    field :partyLabel do
      party_node.text
    end

    field :startDate do
      tds[7].text.tidy.split('/').reverse.join('-')
    end

    field :endDate do
      dstr = tds[8].text.tidy
      return if dstr.include? 'En el cargo'
      dstr.split('/').reverse.join('-')
    end

    private

    def tds
      noko.css('td')
    end

    def region_node
      tds[0].css('a')
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
