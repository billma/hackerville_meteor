isProfileExist = ->
  if Meteor.users.findOne({_id: Session.get "userId" }) then return true else return false

isProfileBelongToCurUser = ->
  return Meteor.userId() == Session.get "userId"

userObj = ->
  return Meteor.users.findOne({_id: Session.get "userId" })


Template.userProfile.isProfileExist = ->
  isProfileExist()

Template.userProfile.user = ->
  userObj()

Template.userProfile.isProfileBelongToCurUser = ->
  isProfileBelongToCurUser()


Template.editUserProfile.isProfileExist = ->
  isProfileExist()

Template.editUserProfile.user = ->
  userObj()

Template.editUserProfile.isProfileBelongToCurUser = ->
  isProfileBelongToCurUser()

Template.editUserProfile.events
  "click #saveUserProfileBtn": ->
    description = $("#editedUserDescription").val()
    id = Session.get "userId"
    Meteor.call( "updateUserProfile", id, description )
    window.location = "/profile/#{Meteor.userId()}"

