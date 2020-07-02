$(document).on('turbolinks:load', function () {
  $('.question').on('click', '.edit-question-link', function(event) {
    event.preventDefault();
    let questionId = $(event.target).data('question');
    $(this).hide();
    $('form#edit-question-' + questionId).removeClass('hidden');
  });
});