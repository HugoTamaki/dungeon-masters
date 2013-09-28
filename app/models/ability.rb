class Ability
  include CanCan::Ability

  def initialize(user)
    can [:manage], Story, user_id: user.id
  end
end