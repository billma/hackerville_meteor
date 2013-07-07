Meteor.Router.add
  '/':
    to: 'index'
    and: () ->
      Session.set 'companyPage', ""
  '/company/suggest':
    to: 'suggestCompanyForm'
  '/admin/approvecompany':
    to: 'pendingCompanies'
  '/room': 'rooms'
  "/rooms/:_id":
    to: "chatPage"
    and: (id) ->
      Session.set 'companyPage', id
      Session.set 'previousPage', id
      console.log "ROUTING TO #{id}"
