#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Retrato'
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[img name start end].freeze
    end

    def empty?
      tds[3].text.to_s.include?('no llegó a asumir') || super
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv