if Companies.find().count() == 0
  Companies.insert
    name: "ToxBox"
    description: "A live video streaming API"
    image: "http://main.makeuseoflimited.netdna-cdn.com/wp-content/uploads/2010/03/TokBoxLogo.png"
    createdAt: new Date().getTime()
    employees:[]
    topUsers: []
    pending: false
    website: "http://www.tokbox.com"
  Companies.insert
    name: "FireBase"
    description: "A live database as a service"
    image: "https://evbdn.eventbrite.com/s3-s3/eventlogos/35241372/firebasebrandingr4final.png"
    createdAt: new Date().getTime()
    employees:[]
    topUsers: []
    pending: false 
    website: "http://www.firebase.com"
  Companies.insert
    name: "Dropbox"
    description: "Provides a data store for all your files!"
    image: "http://appleheadlines.com/wp-content/uploads/2011/08/Dropbox-logo.png"
    createdAt: new Date().getTime()
    employees:[]
    topUsers: []
    pending: false
    website: "http://www.dropbox.com"
  Companies.insert
    name: "Pusher"
    description: "A live date pushing service"
    image: "https://evbdn.eventbrite.com/s3-s3/eventlogos/29352727/pusher.png"
    createdAt: new Date().getTime()
    employees:[]
    topUsers: []
    pending: false
    website: "http://pusher.com"
