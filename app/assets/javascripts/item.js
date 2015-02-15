$(document).ready(function(){
  $('.usable-item').on('click', function() {
    $.ajax({
      url: 'use_item',
      type: 'POST',
      data: {
        "story_id": $(this).data("story-id"),
        "item-id": $(this).data("item-id"),
        "modifier": $(this).data("modifier"),
        "attribute": $(this).data("attribute")
      },
      dataType: "json",
      success: function(data) {
        $(".message-container").html("<p class='message'>" + data["message"] + "</p>");
        setTimeout("$('.message').fadeOut()", 3000);
        $('#adventurer_skill').html(data["skill"]);
        $('#adventurer_energy').html(data["energy"]);
        $('#adventurer_luck').html(data["luck"]);
        $('#adventurer_skill_bar').attr('aria-valuenow', data["skill"]);
        $('#adventurer_energy_bar').attr('aria-valuenow', data["energy"]);
        $('#adventurer_luck_bar').attr('aria-valuenow', data["luck"]);
        $('#adventurer_skill_bar').css('width', (data["skill"] / 12.0) * 100 + '%');
        $('#adventurer_energy_bar').css('width', (data["energy"] / 24.0) * 100 + '%');
        $('#adventurer_luck_bar').css('width', (data["luck"] / 12.0) * 100 + '%');
        if (data["quantity"] > 0) {
          $('#' + data["name"] + '_item').next("#quantity").html(data["quantity"]);
        } else {
          $('#' + data["name"] + '_item').parent().html("<strike>" + data["name"] + "</strike>");
        }
      },
      error: function(response) {
        $(".message-container").html("<p class='message'>" + response["message"] + "</p>");
        setTimeout("$('.message').fadeOut()", 3000);
      }
    })
  });
});