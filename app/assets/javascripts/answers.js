$(document).on('turbolinks:load', function () {
  $('.answers-list').on('click', '.edit-answer-link', function(event) {
    event.preventDefault();
    let answerId = $(event.target).data('answer');
    $(this).hide();
    $('form#edit-answer-' + answerId).removeClass('hidden');
  });

  $('.answers-list').on('click', '.choose-best-answer-link', function(event) {
    event.preventDefault();
    let answerId = $(event.target).data('answer');
    const AUTH_TOKEN = $('meta[name=csrf-token]').attr('content');
    $.ajax({
      method: "PATCH",
      url: '/answers/' + answerId + '/best.js',
      data: { authenticity_token: AUTH_TOKEN }
    }).fail(function() {
         alert( "Error!" );
       });
  });

});