module.exports = function () {
  return `SELECT DISTINCT ?province ?provinceLabel ?office ?officeLabel ?governor ?governorLabel ?start
    WHERE {
      ?province wdt:P31/wdt:P279* wd:Q10864048 ; wdt:P17 wd:Q414 .
      OPTIONAL {
        ?province wdt:P1313 ?office .
        OPTIONAL { 
          ?governor p:P39 ?ps .
          ?ps ps:P39 ?office ; pq:P580 ?start .
          OPTIONAL { ?ps pq:P582 ?end }
          FILTER (!BOUND(?end) || (?end >= NOW()))
        }
      }
      SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
    }
    # ${new Date().toISOString()}
    ORDER BY ?provinceLabel ?officeLabel ?start ?governorLabel`
}
