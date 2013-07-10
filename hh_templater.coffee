# TODO: subject
# TODO: switch to id/name attr for input elements?
# TODO: style the user-facing form
# TODO: reorganize god-awful email-preview divs
  
Emails = new Meteor.Collection 'emails'

Emails.allow {
  update: (userId, doc, fields, modifier) ->
    userId != null
}

if Meteor.isClient
  Template.emailForm.email = ->
    Emails.findOne {}

  Template.emailForm.events {
    'click .js-button-send': (event) ->
      email = Emails.findOne {}

      fields = {
        toAddress: $('.js-input-to-address').val()
        subject: $('.js-input-subject').val()
      }
      Emails.update email._id, {$set: fields}

      Meteor.call 'sendEmail', email, $('#email-preview').html(), $('#text-email-preview').text()

    'click .js-button-save': (event) ->
      email = Emails.findOne {}

      fields = {
        headerImage: $('.js-input-header-image').val()
        venueName: $('.js-input-venue-name').val()
        longDate: $('.js-input-long-date').val()
        startTime: $('.js-input-start-time').val()
        locationName: $('.js-input-location-name').val()
        shortAddress: $('.js-input-short-address').val()
        mapsUrl: $('.js-input-maps-url').val()
        body: $('.js-input-body').val()
        footerImage: $('.js-input-footer-image').val()
        toAddress: $('.js-input-to-address').val()
        subject: $('.js-input-subject').val()
      }

      Emails.update email._id, {$set: fields}
  }

  Template.emailPreview.email = ->
    email = Emails.findOne {}

    if email
      email.defaultStyle = "font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; font-weight: 200; color: #333333; line-height: 1.5;"

    email

if Meteor.isServer
  Meteor.startup ->
    email = Emails.findOne {}
    unless email
      Emails.insert {}

  Accounts.validateNewUser (user) ->
    users = process.env.AUTHORIZED_USERS
    return false unless users

    if users.indexOf(user.emails[0].address) < 0
      console.log(user.emails[0].address + ' not in ' + users)
      return false
    else
      return true

  Meteor.methods {
    sendEmail: (email, html, text) ->
      return unless this.userId

      Email.send {
        to: email.toAddress
        from: 'kevin.lin.p@gmail.com'
        subject: email.subject
        html: html
        text: text
      }
  }
