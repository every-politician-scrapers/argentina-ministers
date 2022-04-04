#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/comparison'

class Comparison < EveryPoliticianScraper::NulllessComparison
  REMAP = {
    'Provincia de Buenos Aires'                                          => 'Buenos Aires',
    'Provincia de Catamarca'                                             => 'Catamarca',
    'Provincia de Corrientes'                                            => 'Corrientes',
    'Provincia de Córdoba'                                               => 'Córdoba',
    'Provincia de Entre Ríos'                                            => 'Entre Ríos',
    'Provincia de Formosa'                                               => 'Formosa',
    'Provincia de Jujuy'                                                 => 'Jujuy',
    'Provincia de La Pampa'                                              => 'La Pampa',
    'Provincia de La Rioja'                                              => 'La Rioja',
    'Provincia de Mendoza'                                               => 'Mendoza',
    'Provincia de Misiones'                                              => 'Misiones',
    'Provincia de Neuquén'                                               => 'Neuquén',
    'Provincia de Río Negro'                                             => 'Río Negro',
    'Provincia de Salta'                                                 => 'Salta',
    'Provincia de San Juan'                                              => 'San Juan',
    'Provincia de San Luis'                                              => 'San Luis',
    'Provincia de Santa Cruz'                                            => 'Santa Cruz',
    'Provincia de Santa Fe'                                              => 'Santa Fe',
    'Provincia de Santiago del Estero'                                   => 'Santiago del Estero',
    'Provincia de Tierra del Fuego, Antártida e islas del Atlántico Sur' => 'Tierra del Fuego',
    'Provincia de Tucumán'                                               => 'Tucumán',
    'Provincia del Chaco'                                                => 'Chaco',
    'Provincia del Chubut'                                               => 'Chubut',
    'Buenos Aires'                                                       => 'Ciudad de Buenos Aires',

    'Frente para la Victoria'                                            => 'Frente para la Victoria-PJ',
    'Partido Justicialista'                                              => 'Justicialista',
    'Propuesta Republicana'                                              => 'Pro',
  }.freeze

  # For now, skip these, as there are far too many differences
  def columns
    super - %i[party partylabel] + %i[psid]
  end

  def wikidata_csv_options
    { converters: [->(v) { REMAP.fetch(v.to_s, v.to_s) }] }
  end
end

diff = Comparison.new('wikidata.csv', 'scraped.csv').diff
puts diff.sort_by { |r| [r.first, r[1].to_s] }.reverse.map(&:to_csv)
