module AdventurersHelper
  def return_real_quantity(modifier_shop)
    real_shop = @adventurer.adventurers_shops.any? {|adv_shop| adv_shop.modifier_shop_id == modifier_shop.id}
    if real_shop
      adventurer_modifier_shop = @adventurer.adventurers_shops.where(modifier_shop_id: modifier_shop.id).first
      return adventurer_modifier_shop.quantity
    else
      return modifier_shop.quantity
    end
  end

  def current_weapon_damage(adventurer)
    @adventurer.selected_weapon ? @adventurer.selected_weapon.damage : 2
  end
end
