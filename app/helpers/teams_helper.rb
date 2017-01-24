module TeamsHelper
    def team_invites
        TeamInvite.where(recipient: current_user)
    end

    def team_admin?
        if user_signed_in? && user_has_team?
            current_team_member.admin
        else
            false
        end
    end

    def current_team_member
        TeamMember.find_by(user: current_user)
    end

    def user_has_team?
        current_team_member.present?
    end

    def current_team
        if user_signed_in? && user_has_team?
            team_member = current_team_member
            Team.find(team_member.team_id) if team_member.present?
        end
    end
    
    def non_team_members
      User.joins(:team).where('teams.id != ?', current_team).select(:username).map{|r| [r.username, nil]}.to_h
    end

    def give_user_rand_team_name
        new_team_name = generate_random_team_name
        team = Team.create!(name: new_team_name)
        TeamMember.create!(user: current_user, team: team, admin: true)
    end

    def generate_random_team_name
        team_name = nil
        nouns_file = File.read(Rails.root + 'lib/assets/nouns.json')
        adjs_file =  File.read(Rails.root + 'lib/assets/adjs.json')

        nouns = JSON.parse(nouns_file)
        adjs = JSON.parse(adjs_file)

        until Team.where(name: team_name).empty? && team_name.present?

            rand_adj = adjs.sample(1).first
            rand_noun = nouns.sample(1).first
            team_name = rand_adj.capitalize + ' ' + rand_noun.capitalize
        end

        team_name
    end
end
