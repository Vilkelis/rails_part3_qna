$(document).on('turbolinks:load', function () {
  $('.answers-list').on('click', '.edit-answer-link', function(event) {
    event.preventDefault();
    let answerId = $(event.target).data('answer');
    $(this).hide();
    $('form#edit-answer-' + answerId).removeClass('hidden');
  });
});