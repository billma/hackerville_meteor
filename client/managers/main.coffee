Template.index.companies = ->
  return Companies.find({pending: false})

Template.index.helpers
  usersCount: ->
    users = Meteor.presences.find {"state.currentRoomId": @_id},
      fields: {state: true, userId: true}
    return users.count()
