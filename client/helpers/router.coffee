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
      Session.set 'previousPage', id
      onlineUserRef = new Firebase("https://hackerville.firebaseIO.com/room/#{id}")
      console.log "ROUTING TO #{id}"
