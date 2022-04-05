const fs = require('fs');
let rawmeta = fs.readFileSync('meta.json');
let meta = JSON.parse(rawmeta);

module.exports = (label,region,began,ended) => {
  mem = {
    value: meta.position,
    qualifiers: {
      P768: region,
    },
    references: {
      P4656: meta.source,
      P813: new Date().toISOString().split('T')[0],
      P1810: label,
    }
  }
  if(began) mem['qualifiers']['P580']  = began
  if(ended) mem['qualifiers']['P582']  = ended

  claims = {
    P31: { value: 'Q5' }, // human
    P106: { value: 'Q82955' }, // politician
    P39: mem,
  }

  return {
    type: 'item',
    labels: { en: label },
    descriptions: { en: 'politician in Argentina' },
    claims: claims,
  }
}
