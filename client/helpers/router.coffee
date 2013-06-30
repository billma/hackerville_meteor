Meteor.Router.add
  '/':
    to: 'index'
    and: () ->
      Session.set 'companyPage', ""
  '/room': 'rooms'
  "/rooms/:_id":
    to: "chatPage"
    and: (id) ->
      Session.set 'companyPage', id
      #setInterval ()->
      #  $("abbr.timeago").timeago()
      #, 1000
