ISODateString = (d)->
 pad = (n)->
  if n<10
    return '0'+n
  else
    return n
 str = d.getUTCFullYear()+'-'
 str += pad(d.getUTCMonth()+1)+'-'
 str += pad(d.getUTCDate())+'T'
 str += pad(d.getUTCHours())+':'
 str += pad(d.getUTCMinutes())+':'
 str += pad(d.getUTCSeconds())+'Z'
 return str

Template.index.companies = ->
  return Companies.find()

Template.chatPage.helpers
  companyInfo: ->
    return Companies.findOne({ _id: Session.get "companyPage" })
  current: ->
    return Meteor.user()
  messages: ->
    return Messages.find({ companyId: Session.get "companyPage" }, {sort: {createdAt: -1}})
  disableVote: ->
    if _.contains( @voters, Meteor.user()._id )
      return "disabled"
    return "enabled"

Template.chatPage.events
  "click .vote.enabled": (e) ->
    @voters.push Meteor.user()._id
    Messages.update({_id: this._id}, {$set: {votes: @votes+1, voters: @voters}})
  "keydown #write-chat": (e) ->
    if e.keyCode == 13
      Messages.insert
        "message": $(e.target).val()
        "companyId": Session.get "companyPage"
        "createdAt": ISODateString(new Date())
        "userId": Meteor.user()._id
        "name": Meteor.user().profile.name
        "votes": 0
        "voters": []
      $(e.target).val("")



Template.onlineUsers.created = ->
  company = Companies.findOne({ _id: Session.get "companyPage" })
  onlineUserRef = new Firebase("https://hackerville.firebaseIO.com/room/#{company._id}")
  if Meteor.user()
    console.log "user is alive"
    userRef = new Firebase("https://hackerville.firebaseIO.com/room/#{company._id}/#{Meteor.user()._id}")
    userRef.set {points: Meteor.user().profile.points, name: Meteor.user().profile.name, picture: Meteor.user().profile.picture }
    userRef.onDisconnect().remove()

  onlineUserRef.on 'value', (snap) ->
    users = snap.val()
    if !users
      return
    window.users = users
    $("#onlineUsersContainer").html ""
    for k,v of users
      onlineUserTemplate = "onlineUser"
      fragment = Meteor.render ->
        Template[ onlineUserTemplate ](v)
      $("#onlineUsersContainer").append fragment
      console.log fragment
      console.log v.name
      console.log v.picture


Template.onlineUsers.onlineUserList = ->


