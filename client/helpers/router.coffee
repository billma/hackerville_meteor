Meteor.Router.add
  '/': 'index'
  '/room': 'rooms'
  "/:_id":
    to: "chatPage"
    and: (id) ->
      Session.set 'companyPage', id
