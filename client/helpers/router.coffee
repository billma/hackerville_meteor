Meteor.Router.add
  '/':
    to: 'index'
    and: () ->
      Session.set 'companyPage', ""
  '/company/suggest':
    to: 'suggestCompanyForm'
  '/profile/:_id':
    to: 'userProfile'
    and: (id) ->
      console.log id
      Session.set 'userId', id
  '/profile/:_id/edit':
    to: 'editUserProfile'
    and: (id) ->
      console.log id
      Session.set 'userId', id
  '/admin/approvecompany':
    to: 'pendingCompanies'
  '/room': 'rooms'
  "/rooms/:_id":
    to: "chatPage"
    and: (id) ->
      Session.set 'companyPage', id
      Session.set 'previousPage', id
      console.log "ROUTING TO #{id}"
