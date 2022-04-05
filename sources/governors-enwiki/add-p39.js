module.exports = (id, position, startdate, enddate) => {
  qualifier = {
    P580: '2017-08-08'
  }

  if(startdate) qualifier['P580'] = startdate
  if(enddate)   qualifier['P582'] = enddate

  return {
    id,
    claims: {
      P39: {
        value: position,
        qualifiers: qualifier,
        references: {
          P4656: 'https://en.wikipedia.org/wiki/Counties_of_Kenya',
          P813: new Date().toISOString().split('T')[0],
        }
      }
    }
  }
}
