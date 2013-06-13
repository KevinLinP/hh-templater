Emails = new Meteor.Collection 'emails'

# TODO: subject
# TODO: switch to id/name attr for input elements?
# TODO: style the user-facing form
  
if Meteor.isClient
  Template.emailForm.email = ->
    Emails.findOne {}

  Template.emailForm.events {
    'click .js-button-send': (event) ->
      email = Emails.findOne {}
      Meteor.call 'sendEmail', email, $('#email-preview').html(), $('#text-email-preview').text()

    'click .js-button-save': (event) ->
      subject = $('.js-input-subject').val()

      email = Emails.findOne {}
      unless email
        Emails.insert {}
        email = Emails.findOne {}
      
      fields = {
        headerImage: $('.js-input-header-image').val()
        venueName: $('.js-input-venue-name').val()
        longDate: $('.js-input-long-date').val()
        shortAddress: $('.js-input-short-address').val()
        mapsUrl: $('.js-input-maps-url').val()
        body: $('.js-input-body').val()
        footerImage: $('.js-input-footer-image').val()
        toAddress: $('.js-input-to-address').val()
        fromAddress: $('.js-input-from-address').val()
        subject: subject
      }

      Emails.update email._id, {$set: fields}
  }

  Template.emailPreview.email = ->
    email = Emails.findOne {}
    email.defaultStyle = "font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; font-weight: 200; color: #333333; line-height: 1.5;"
    email

if Meteor.isServer
  Meteor.methods {

    sendEmail: (email, html, text) ->
      Email.send {
        to: email.toAddress
        from: email.fromAddress
        subject: email.subject
        html: html
        text: text
      }

  }
