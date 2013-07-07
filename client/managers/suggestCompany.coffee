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
  "click .deleteCompany": ->
    response = confirm("Are you sure you want to delete it?")
    if response
      Companies.remove({_id: this._id})
    return
  "click .editCompany": ->
    $("#cName").val( this.name )
    $("#cPic").val( this.image )
    $("#cWebsite").val( this.website )
    $("#cDescription").text( this.description )
    $("#cId").val( this._id )
    $("#editModal").modal({keyboard: true})
  "click #saveChanges": ->
    Companies.update({_id: $("#cId").val() }, {$set: { name: $("#cName").val(), website: $("#cWebsite").val(), image: $("#cPic").val(), createdAt: new Date().getTime(), description: $("#cDescription").val() }})
    $("#editModal").modal('hide')


Template.currentCompanies.activeCompanies = ->
  return Companies.find({pending: false})

Template.currentCompanies.helpers
  "printTime": ->
    return new Date(this.createdAt)


