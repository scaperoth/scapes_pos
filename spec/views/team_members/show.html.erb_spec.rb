require 'rails_helper'

RSpec.describe "team_members/show", type: :view do
  before(:each) do
    @team_member = assign(:team_member, TeamMember.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
