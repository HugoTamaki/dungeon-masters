module ItemsHelper
  def show_item(adventurer_item, item, chapter)
    if item.is_a? UsableItem
      if adventurer_item.quantity > 0
        "<p>" + 
        link_to(item.name, "javascript:;", id: "#{item.name.parameterize.underscore}_item", data: {story_id: "#{chapter.story.id}", item_id: "#{item.id}",attribute: "#{item.attr}", modifier: "#{item.modifier}"}, class: "usable-item") + 
        " - <span id='quantity'>#{adventurer_item.quantity}</span>" +
        "</p>"
      else
        "<p>" + 
        "<strike>#{item.name}</strike> - " + 
        "<span id='quantity'>#{adventurer_item.quantity}</span>" + 
        "</p>"
      end
    elsif item.is_a? KeyItem
      if adventurer_item.quantity > 0
        "<p>" + 
        "#{item.name} - #{adventurer_item.quantity} - item chave" + 
        "</p>"
      else
        "<p>" + 
        "<strike>#{item.name} - #{adventurer_item.quantity} - item chave</strike>" + 
        "</p>"
      end
    end
  end
end