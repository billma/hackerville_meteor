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
    if $("#messages")[0]
      $("#messages")[0].scrollTop = $("#messages")[0].scrollHeight
      window.app.renderedScrollTop = $("#messages")[0].scrollTop

Meteor.Presence.state = ->
  a =
    online: true
    currentRoomId: Session.get('companyPage')
  return a

Template.userTemplate.helpers
   userData: ->
     Meteor.users.findOne({_id:@userId})

Template.onlineUsersTemplate.userPresences = ->
  users = Meteor.presences.find {"state.currentRoomId": Session.get('companyPage')},
    transform: (doc) ->
      user = Meteor.users.findOne({_id:doc.userId})
      if(user)
        doc.profile = user.profile
      return doc
    fields: {state: true, userId: true}
  distinct = users.distinct "userId"
  $("#roomOnlineCounter").text(distinct.length)
  return distinct

