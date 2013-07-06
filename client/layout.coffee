Template.headerContent.events
  "click #companyTitle": ->
    window.location = "/"

Template.loginButton.helpers
  buttonText: ->
    if Meteor.user()
      return "signout"
    return "Login"

Template.loginButton.events
  "click #loginButton": (e)->
    target = $(e.target)
    if target.text() == "signout"
      user = Meteor.user()
      Meteor.logout ->
        target.text("Login")
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

