module Abilities
  class Everyone
    include CanCan::Ability

    def initialize(_)
      can :read, :all
      can [:home, :titleshow], Page
      can [:perdag, :month], Agendaitem
      can [:frontpage, :records], Result
      can :hide, Announcement
      can :create, [Chatmessage, User]
      cannot :read, [User, Photoalbum, Photo, Announcement]
      cannot :see_email, Commission
    end
  end
end
