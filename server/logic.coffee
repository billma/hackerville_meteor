Accounts.onCreateUser (options, user) ->
  options.profile.name = user.services.facebook.name
  options.profile.picture = "http://graph.facebook.com/" + user.services.facebook.id + "/picture?type=square"
  options.profile.points = 0
  user.profile = options.profile
  return user

Accounts.loginServiceConfiguration.insert
  service: "facebook"
  appId: "187865891375322"
  secret: "794bc03179735a642abb22b3f596c912"
