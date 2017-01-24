class TeamInvite < ActiveRecord::Base
  belongs_to :team
  belongs_to :sender, :class_name => "User"
  belongs_to :recipient, :class_name => "User"
end
