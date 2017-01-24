$(document).on 'turbolinks:load', ->
  usernames = $('#team_invite_recipient').data('url')
  $('#team_invite_recipient').autocomplete 
    data: usernames
    
      