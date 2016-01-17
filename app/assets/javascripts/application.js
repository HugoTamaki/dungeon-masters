// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery.remotipart
//= require bootstrap.min
//= require summernote.min
//= require jquery.qtip.min
//= require cytoscape.min
//= require cytoscape-qtip
//= require_tree .
//= require jquery-ui
//= require remove-image

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g");
  if (association == "decisions" ||
    association == "monsters" ||
    association == "modifiers_items" ||
    association == "modifiers_attributes" ||
    association == "modifiers_shops") {
    $(link).before(content.replace(regexp, new_id));
  } else {
    $(link).parent().before(content.replace(regexp, new_id));
  }
}

function remove_fields(link, form) {
  $(link).prev("input[type=hidden]").val("1");
  //$(link).closest("."+form+"-fields").remove();
  $(link).closest("."+form+"-fields").hide();
}

$(document).ready(function(){

  $(function() {
    $("#tabs").tabs();
  });

  function isEmailValid(str) {
    var pattern = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;

    return str.match(pattern) !== null;
  }

  checkbox = '<div class="checkbox">';
  checkbox += '<label>';
  checkbox += '<input type="checkbox" id="howdy" name="howdy" value="yeah"> Não sou um bot!';
  checkbox += '</label>';
  checkbox += '</div>';
  $('#check').html(checkbox);

  $('#contact-form').submit(function(event) {
    if ($('#email').val() !== '' && isEmailValid($('#email').val()) && $('#message').val() !== '' && $('#howdy')[0].checked) {
      return true;
    }
    $('.errors').addClass('alert alert-danger').html('Insira seus dados corretamente');
    return false;
  })

  // $('.chapter-fields').accordion({
  //   active: false,
  //   collapsible: true,
  //   header: '.accordionButton',
  //   heightStyle: "content",
  //   autoHeight: false,
  //   clearStyle: true,
  // });

  $('.summernote').summernote({
    height: 330,
    toolbar: [
      //[groupname, [button list]]
       
      ['style', ['bold', 'italic', 'underline', 'clear']],
      ['fontsize', ['fontsize']],
      ['color', ['color']],
      ['para', ['ul', 'ol', 'paragraph']],
      ['height', ['height']]
    ]
  });

  $('.summernote').each(function(){
    $(this).next().children(".note-editable").html($(this).val());
  });

  $('.edit_chapter').submit(function(){
    $('.note-editable').each(function(){
      $(this).parent().prev().val($(this).html());
    });
    return true;
  });

  $(function() {
    $(document).tooltip({
      tooltipClass: "tooltip-style"
    });
  });

  function fadeMessage(){
    $('#message').fadeOut('slow');//just a function to fade out the message
  }

  $(document).on('click', 'input[value="UsableItem"]', function() {
    $(this).closest('.input-group').next('.usable-item-attributes').addClass('visible');
    $(this).closest('.input-group').next().next().removeClass('visible');
    $(this).closest('.input-group').next().next().next().removeClass('visible');
  });

  $(document).on('click', 'input[value="Weapon"]', function() {
    $(this).closest('.input-group').next('.usable-item-attributes').removeClass('visible');
    $(this).closest('.input-group').next().next().addClass('visible');
    $(this).closest('.input-group').next().next().next().removeClass('visible');
  });

  $(document).on('click', 'input[value="KeyItem"]', function() {
    $(this).closest('.input-group').next('.usable-item-attributes').removeClass('visible');
    $(this).closest('.input-group').next().next().removeClass('visible');
    $(this).closest('.input-group').next().next().next().addClass('visible');
  });

});
