#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator ReplaceZeroWidthSpaces
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Designado'
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[start _ name _ _ _ end].freeze
    end

    def itemLabel
      super.tidy
    end

    def startDate
      start_cell.css('span').map(&:text).first.to_s.delete_prefix('0').tidy
    end

    def endDate
      end_cell.css('span').map(&:text).first.to_s.delete_prefix('0').tidy
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
