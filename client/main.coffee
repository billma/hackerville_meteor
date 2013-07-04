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

Template.loginButton.helpers
  buttonText: ->
    if Meteor.user()
      return "signout"
    return "Login With Facebook"

Template.loginButton.events
  "click #loginButton": (e)->
    target = $(e.target)
    if target.text() == "signout"
      user = Meteor.user()
      Meteor.logout ->
        target.text("Login With Facebook")
        companyId = Session.get "companyPage"
        if companyId
          userRef = new Firebase("https://hackerville.firebaseIO.com/room/#{companyId}/#{user._id}")
          userRef.remove()
        return
      return
    Meteor.loginWithFacebook {}, (err) ->
      target.text("signout")
      companyId = Session.get "companyPage"
      console.log "User present in chat"
      console.log Meteor.user()
      console.log companyId
      if companyId and Meteor.user()
        console.log "setting new user"
        userRef = new Firebase("https://hackerville.firebaseIO.com/room/#{companyId}/#{Meteor.user()._id}")
        userRef.set {points: Meteor.user().profile.points, name: Meteor.user().profile.name, picture: Meteor.user().profile.picture }
        userRef.onDisconnect().remove()
    return

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
    if !Meteor.user() or _.contains( @voters, Meteor.user()._id )
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

window.myUsers = {}

showUsers = () ->
  console.log "displaying users"
  $("#onlineUsersContainer").html ""
  for k,v of window.myUsers
    html = """ 
      <div>
        <img src="#{v.picture}" alt="" />
        #{v.points}: #{v.name}
      </div>
      <hr />
    """
    $("#onlineUsersContainer").append html
window.showUsers = showUsers

valueChangedOnline = (snap) ->
  window.myUsers = snap.val()
  showUsers()
  return


Deps.autorun ->
  showUsers()

Template.onlineUsers.rendered = ->
  showUsers()
Template.onlineUsers.created = ->
  company = Companies.findOne({ _id: Session.get "companyPage" })
  onlineUserRef = new Firebase("https://hackerville.firebaseIO.com/room/#{company._id}")
  if Meteor.user()
    userRef = new Firebase("https://hackerville.firebaseIO.com/room/#{company._id}/#{Meteor.user()._id}")
    userRef.set {points: Meteor.user().profile.points, name: Meteor.user().profile.name, picture: Meteor.user().profile.picture }
    userRef.onDisconnect().remove()
  onlineUserRef.on 'value', valueChangedOnline

Template.onlineUsers.destroyed = ->
  onlineUserRef = new Firebase("https://hackerville.firebaseIO.com/room/#{Session.get 'previousPage'}")
  onlineUserRef.off 'value', valueChangedOnline
  if Meteor.user()
    company = Companies.findOne({ _id: Session.get "previousPage" })
    userRef = new Firebase("https://hackerville.firebaseIO.com/room/#{company._id}/#{Meteor.user()._id}")
    userRef.remove()


