Meteor.Router.add
  '/': 'index'
  '/room': 'rooms'
  "/rooms/:_id":
    to: "chatPage"
    and: (id) ->
      Session.set 'companyPage', id
      #setInterval ()->
      #  $("abbr.timeago").timeago()
      #, 1000
