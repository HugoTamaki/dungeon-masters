module ItemsHelper
  def show_item(adventurer_item, item, chapter)
    result = ""
    if item.is_a? Weapon
      result += "<p>"
      result += link_to(item.name, story_select_weapon_path(adventurer_id: adventurer_item.adventurer, item_id: item))
      result += " dano: #{item.damage}"
      if adventurer_item.selected
        result += " <i class='fa fa-hand-o-left'></i>"
      end
      result += "</p>"
    elsif item.is_a? UsableItem
      if adventurer_item.quantity > 0
        result += "<p>"
        result += link_to(item.name, "javascript:;", id: "#{item.name.parameterize.underscore}_item", data: {story_id: "#{chapter.story.id}", item_id: "#{item.id}",attribute: "#{item.attr}", modifier: "#{item.modifier}"}, class: "usable-item")
        result += " - <span id='quantity'>#{adventurer_item.quantity}</span>"
        result += "</p>"
      else
        result += "<p>"
        result += "<strike>#{item.name}</strike> - "
        result += "<span id='quantity'>#{adventurer_item.quantity}</span>"
        result += "</p>"
      end
    elsif item.is_a? KeyItem
      if adventurer_item.quantity > 0
        result += "<p>"
        result += "#{item.name} - #{adventurer_item.quantity} - item chave"
        result += "</p>"
      else
        result += "<p>"
        result += "<strike>#{item.name} - #{adventurer_item.quantity} - item chave</strike>"
        result += "</p>"
      end
    end
    result
  end
end