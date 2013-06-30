Template.loginButton.events
  "click #loginButton": (e)->
    console.log "clicked button"
    target = $(e.target)
    if target.text() == "signout"
      console.log "logging out man"
      Meteor.logout ->
        target.text("Login With Facebook")
        console.log "logged out"
        return
      return
      
    Meteor.loginWithFacebook {}, (err) ->
      target.text("signout")
    return


Template.index.companies = ->
  return Companies.find()

Template.chatPage.helpers
  companyInfo: ->
    return Companies.findOne({ _id: Session.get "companyPage" })
  messages: ->
    return Messages.find({ companyId: Session.get "companyPage" }, {sort: {createdAt: -1}})
  disableVote: ->
    if !Meteor.user() or _.contains( @voters, Meteor.user()._id )
      return "disabled"
    return "enabled"

Template.chatPage.events
  "click .vote.enabled": (e) ->
    @voters.push Meteor.user()._id
    Messages.update({_id: this._id}, {$set: {votes: @votes+1, voters: @voters}})
  "keydown #messageInput": (e) ->
    if e.keyCode == 13
      Messages.insert
        "message": $(e.target).val()
        "companyId": Session.get "companyPage"
        "createdAt": new Date().getTime()
        "userId": Meteor.user()._id
        "name": Meteor.user().profile.name
        "votes": 0
        "voters": []
      $(e.target).val("")

userRef = ""


Template.onlineUsers.created = ->
  company = Companies.findOne({ _id: Session.get "companyPage" })
  onlineUserRef = new Firebase("https://hackerville.firebaseIO.com/room/#{company._id}")
  if Meteor.user()
    userRef = new Firebase("https://hackerville.firebaseIO.com/room/#{company._id}/#{Meteor.user()._id}")
    userRef.set {points: Meteor.user().profile.points, name: Meteor.user().profile.name, picture: Meteor.user().profile.picture }
    userRef.onDisconnect().remove()

  onlineUserRef.on 'value', (snap) ->
    users = snap.val()
    if !users
      return
    $("#onlineUsersContainer").html ""
    for k,v of users
      onlineUserTemplate = "onlineUser"
      fragment = Meteor.render ->
        Template[ onlineUserTemplate ](v)
      $("#onlineUsersContainer").append fragment
      console.log fragment

  Deps.autorun ->
    if Meteor.user()
      userRef = new Firebase("https://hackerville.firebaseIO.com/room/#{company._id}/#{Meteor.user()._id}")
      userRef.set {points: Meteor.user().profile.points, name: Meteor.user().profile.name, picture: Meteor.user().profile.picture }
      userRef.onDisconnect().remove()
    else
      if userRef != ""
        userRef.remove()
        userRef = ""


Template.onlineUsers.destroyed = ->
  if Meteor.user()
    company = Companies.findOne({ _id: Session.get "companyPage" })
    userRef = new Firebase("https://hackerville.firebaseIO.com/room/#{company._id}/#{Meteor.user()._id}")
    userRef.remove()

