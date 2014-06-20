$(document).ready(function() {
  $(".remove").click(function() {
    var chapterId = $(this).parent().prev().find("input").val();
    var imageDiv = $(this).parent().prev().prev();

    $.ajax({
      url: 'erase_image',
      type: 'GET',
      data: {
        chapter_id: chapterId
      },
      success: function() {
        imageDiv.html("<p>Image removed.</p>");
      },
      error: function() {
        imageDiv.html("<p>Oops, image could not be removed.</p>")
      }
    });
  });
});