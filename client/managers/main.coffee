Template.index.companies = ->
  return Companies.find({pending: false})


