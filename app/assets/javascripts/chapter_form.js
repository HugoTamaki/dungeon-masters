$(document).ready(function(){
  $('.edit_chapter')
    .bind("ajax:beforeSend", function(){
      var submitButton = $(this).find('input[name="commit"]');
      submitButton.attr('value', 'Enviando...');
      submitButton.addClass('disabled');
      $('.message-container').removeClass('alert alert-success');
      $('.message-container').removeClass('alert alert-danger');
    })
    .bind("ajax:success", function(evt, data, status, xhr){
      $('.message-container').fadeIn();
      $('.message-container').addClass('alert alert-success');
      $('.message-container').html('Capitulo salvo com sucesso');
      $('.message-container').fadeOut(2000);
    })
    .bind("ajax:error", function(evt, xhr, status, error){
      var errors = xhr.responseJSON.error;
      var messages = '';
      for(i=0;i<errors.length;i++) {
        messages += errors[i] + '<br/>'
      }
      $('.message-container').fadeIn();
      $('.message-container').addClass('alert alert-danger');
      $('.message-container').html(messages);
      $('.message-container').fadeOut(2000);
    })
    .bind("ajax:complete", function() {
      var submitButton = $(this).find('input[name="commit"]');
      submitButton.attr('value', 'Salvar');
      submitButton.removeClass('disabled');
    });
});