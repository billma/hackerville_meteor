Template.suggestCompanyForm.events
  "click #createNewCompany": ->
    company = Companies.insert
                name: $("#companyName").val()
                description: $("#companyDescription").val()
                image: $("#companyPic").val()
                createdAt: new Date().getTime()
                employees: []
                topUsers: []
                pending: true
    window.location = "/"

Template.pendingCompanies.companies = ->
  return Companies.find({pending: true})
