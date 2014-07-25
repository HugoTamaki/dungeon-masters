$(document).ready(function(){
  $('.usable-item').on('click', function() {
    $.ajax({
      url: 'use_item',
      type: 'POST',
      data: {
        "item-id": $(this).data("item-id"),
        "modifier": $(this).data("modifier"),
        "attribute": $(this).data("attribute")
      },
      dataType: "json",
      success: function(data) {
        $(".message-container").html("<p class='message'>Adventurer updated.</p>");
        $('#adventurer_skill').html(data["skill"]);
        $('#adventurer_energy').html(data["energy"]);
        $('#adventurer_luck').html(data["luck"]);
        $('#' + data["name"] + '_item').parent().html("<strike>" + data["name"] + "</strike>");
      },
      error: function() {
        
      }
    })
  });
});