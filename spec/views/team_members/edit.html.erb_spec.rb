require 'rails_helper'

RSpec.describe "team_members/edit", type: :view do
  before(:each) do
    @team_member = assign(:team_member, TeamMember.create!())
  end

  it "renders the edit team_member form" do
    render

    assert_select "form[action=?][method=?]", team_member_path(@team_member), "post" do
    end
  end
end
