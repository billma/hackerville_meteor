Accounts.onCreateUser (options, user) ->
  options.profile.name = user.services.facebook.name
  options.profile.picture = "http://graph.facebook.com/" + user.services.facebook.id + "/picture?type=square"
  options.profile.points = 0
  options.profile.description = null
  user.profile = options.profile
  return user

Accounts.loginServiceConfiguration.insert
  service: "facebook"
  appId: "187865891375322"
  secret: "794bc03179735a642abb22b3f596c912"



Meteor.publish 'userPresence', ->
  filter = {}
  return Meteor.presences.find(filter, {fields: {state: true, userId: true}})


Meteor.methods
  updateUserPoints: ( id, dir ) ->
    origPoints = Meteor.users.findOne({_id: id}).profile.points
    if dir == -1
      Meteor.users.update({_id: id}, {$set: {"profile.points": origPoints-1 }})
    if dir == 1
      Meteor.users.update({_id: id}, {$set: {"profile.points": origPoints+1 }})
  updateUserProfile: ( id, description ) ->
    Meteor.users.update({_id: id }, {$set: {"profile.description": description }})
    console.log Meteor.users.findOne({_id: id})
      
