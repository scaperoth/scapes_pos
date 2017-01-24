require 'rails_helper'

RSpec.describe "team_members/new", type: :view do
  before(:each) do
    assign(:team_member, TeamMember.new())
  end

  it "renders new team_member form" do
    render

    assert_select "form[action=?][method=?]", team_members_path, "post" do
    end
  end
end
