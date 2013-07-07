Template.suggestCompanyForm.events
  "click #createNewCompany": ->
    company = Companies.insert
                name: $("#companyName").val()
                description: $("#companyDescription").val()
                image: $("#companyPic").val()
                createdAt: new Date().getTime()
                website: $("#companyWebsite").val()
                employees: []
                topUsers: []
                pending: true
    window.location = "/"

Template.pendingCompanies.companies = ->
  return Companies.find({pending: true})

Template.pendingCompanies.helpers
  "printTime": ->
    return new Date(this.createdAt)

Template.pendingCompanies.events
  "click .approveCompany": (e) ->
    console.log this._id
    Companies.update({_id: this._id}, {$set: { pending: false }})
