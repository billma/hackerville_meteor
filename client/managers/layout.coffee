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
      console.log "Welcome! Thank you for logging in!"
    return

