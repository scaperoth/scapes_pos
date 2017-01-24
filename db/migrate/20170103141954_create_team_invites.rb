class CreateTeamInvites < ActiveRecord::Migration
  def change
    create_table :team_invites do |t|
      t.references :team, index: true
      t.references :sender, :class_name => "User"
      t.references :recipient, :class_name => "User"

      t.timestamps
    end
  end
end
