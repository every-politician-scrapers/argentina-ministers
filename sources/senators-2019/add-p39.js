const fs = require('fs');
let rawmeta = fs.readFileSync('meta.json');
let meta = JSON.parse(rawmeta);

module.exports = (id, label, region, began, ended) => {
  qualifier = { }
  if(region) qualifier['P768'] = region
  if(began)  qualifier['P580'] = began
  if(ended)  qualifier['P582'] = ended

  reference = {}

  if(meta.source) {
    var wpref = /wikipedia.org/;
    if (wpref.test(meta.source)) {
      reference['P4656'] = meta.source
    } else {
      reference['P854'] = meta.source
    }
  }
  reference['P813'] = new Date().toISOString().split('T')[0]
  reference['P1810'] = label

  return {
    id,
    claims: {
      P39: {
        value: meta.position,
        qualifiers: qualifier,
        references: reference,
      }
    }
  }
}
