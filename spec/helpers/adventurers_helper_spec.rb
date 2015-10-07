require 'spec_helper'

describe AdventurersHelper do
  let(:user) { FactoryGirl.create(:user) }
  let(:story) { FactoryGirl.create(:story) }
  let(:chapter) { FactoryGirl.create(:chapter, story: story) }
  let(:item) { FactoryGirl.create(:item) }
  let(:modifier_shop) { FactoryGirl.create(:modifier_shop, chapter: chapter, item: item, quantity: 4) }
  let(:adventurer) { FactoryGirl.create(:adventurer, user: user) }

  describe '#return_real_quantity' do
    context "shop is related to adventurer" do
      let(:adventurer_shop) { FactoryGirl.create(:adventurer_shop, adventurer: adventurer, modifier_shop: modifier_shop, quantity: 3) }

      it "returns adventurer_modifier_shop" do
        adventurer_shop
        @adventurer = adventurer
        expect(helper.return_real_quantity(modifier_shop)).to eql(3)
      end
    end

    context "shop is not related to adventurer" do
      it "returns modifier_shop quantity" do
        @adventurer = adventurer
        expect(helper.return_real_quantity(modifier_shop)).to eql(4)
      end
    end
  end

  describe '#current_weapon_damage' do
    let(:sword) { FactoryGirl.create(:weapon, name: 'Espada', damage: 4) }
    let(:lance) { FactoryGirl.create(:weapon, name: 'Lança', damage: 3) }

    context 'there is a selected weapon' do
      before do
        adventurer.items << lance
        adventurer.items << sword
        adventurer_item = adventurer.adventurers_items.last
        adventurer_item.update(selected: true)
      end

      it 'returns damage of selected weapon' do
        expect(helper.current_weapon_damage(adventurer)).to eql(4)
      end
    end

    context 'there is not a selected weapon' do
      before do
        adventurer.items << lance
        adventurer.items << sword
      end

      it 'returns default number' do
        expect(helper.current_weapon_damage(adventurer)).to eql(2)
      end
    end
  end
end