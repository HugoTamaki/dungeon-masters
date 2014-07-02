class Ability
  include CanCan::Ability

  def initialize(user)
    # alias_action :create, :edit, :update, :destroy, :to => :crud

    can :manage, Story, :user_id => user.id
    can :read, Story
  end
end