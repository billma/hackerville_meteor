loginButtonClickHandler = (e)->
  target = $(e.target)
  icon = target[0].firstElementChild.className
  if target.text() == "signout" || icon == "icon-signout"
    user = Meteor.user()
    Meteor.logout ->
      target.text("login")
      companyId = Session.get "companyPage"
      if companyId
        userRef = new Firebase("https://hackerville.firebaseIO.com/room/#{companyId}/#{user._id}")
        userRef.remove()
      return
    return
  Meteor.loginWithFacebook {}, (err) ->
    console.log "Welcome! Thank you for logging in!"
  return

headerContentEvents =
  "click .logo": ->
    window.location = "/"
  "click .loginButton": loginButtonClickHandler
  "click .menu-mobile": ->
    $('.menu-list').toggleClass('hidden', 'show')

headerContentHelpers =
  buttonText: ->
    if Meteor.user()
      return "signout"
    return "login"
  buttonIcon: ->
    if Meteor.user()
      return "icon-signout"
    return "icon-signin"
  currentUser: ->
    return Meteor.user()

# Desktop and tablet template
Template.headerContent.events headerContentEvents
Template.headerContent.helpers headerContentHelpers

# Mobile template
Template.headerContentMobile.events headerContentEvents
Template.headerContentMobile.helpers headerContentHelpers


