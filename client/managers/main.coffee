
roomlistHelper =
  usersCount: ->
    users = Meteor.presences.find {"state.currentRoomId": @_id},
      fields: {state: true, userId: true}
    return users.count()
  companies: ->
    return Companies.find({pending: false})

Template.roomListMobile.helpers roomlistHelper
Template.roomList.helpers roomlistHelper
Template.index.helpers roomlistHelper

