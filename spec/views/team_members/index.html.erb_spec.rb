require 'rails_helper'

RSpec.describe "team_members/index", type: :view do
  before(:each) do
    assign(:team_members, [
      TeamMember.create!(),
      TeamMember.create!()
    ])
  end

  it "renders a list of team_members" do
    render
  end
end
