Meteor.Router.add
  '/':
    to: 'index'
    and: () ->
      Session.set 'companyPage', ""
  '/room': 'rooms'
  "/:_id":
    to: "chatPage"
    and: (id) ->
      Session.set 'companyPage', id
