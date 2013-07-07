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

Template.chatPage.helpers
  companyInfo: ->
    return Companies.findOne({ _id: Session.get "companyPage" })
  current: ->
    return Meteor.user()
  messages: ->
    return Messages.find({ companyId: Session.get "companyPage" }, {sort: {createdAt: 1}})
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
      if $(e.target).val().replace(/\s+/g, "").length > 0
        Messages.insert
          "message": $(e.target).val()
          "companyId": Session.get "companyPage"
          "createdAt": ISODateString(new Date())
          "userId": Meteor.user()._id
          "name": Meteor.user().profile.name
          "votes": 0
          "voters": []
        $(e.target).val("")
      else
        $(e.target).val("")
  "scroll #messages": (e)->
    window.app.userScrollTop = e.target.scrollTop

window.app = window.app || {}
window.app.renderedScrollTop = 0
window.app.userScrollTop = 0

Template.chatPage.rendered = ->
  if window.app.userScrollTop >= (window.app.renderedScrollTop-30) || window.app.userScrollTop == 0
    $("#messages")[0].scrollTop = $("#messages")[0].scrollHeight
    window.app.renderedScrollTop = $("#messages")[0].scrollTop

window.myUsers = {}

showUsers = () ->
  console.log "displaying users"
  $("#onlineUsersContainer").html ""
  for k,v of window.myUsers
    html = """ 
      <div class="user online">
        <img src="#{v.picture}" alt="" class="img-circle" />
        #{v.name} - #{v.points}
      </div>
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


