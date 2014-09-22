class Ability
  include CanCan::Ability

  def initialize(account)
    account ||= Account.new

    if account.admin?
      can :manage, :all
    else
      can :manage, Account, id: account.id
      can :manage, Subscription, account_id: account.id
    end
  end
end
