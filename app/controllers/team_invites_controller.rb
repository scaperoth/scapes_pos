class TeamInvitesController < ApplicationController
    before_filter :set_team_invite, only: [:destroy]
    before_filter :authenticate_team!

    # GET /team_invites
    # GET /team_invites.json
    def index
        @team_invites = TeamInvite.where(team: current_team)
    end

    # GET /team_invites/new
    def new
        @team_invite = TeamInvite.new
    end

    # POST /team_invites
    # POST /team_invites.json
    def create
        @team_invite = TeamInvite.new(team_invite_params)
        respond_to do |format|
            if @team_invite.save
                format.html { redirect_to team_team_invites_url, notice: 'TeamInvite was successfully created.' }
                format.json { render :show, status: :created, location: team_team_invites_url }
            else
                format.html { render :new }
                format.json { render json: @team_invite.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /team_invites/1
    # DELETE /team_invites/1.json
    def destroy
        @team_invite.destroy
        respond_to do |format|
            format.html { redirect_to team_team_invites_url, notice: 'Invite was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    def accept
        # get new team details
        new_team = Team.find(params[:team])
        invite = TeamInvite.where(recipient: current_user, team: new_team)

        respond_to do |format|
            if invite.empty?
                format.html { redirect_to :back, notice: 'You need an invitation to join this team.' }
                format.json { render json: new_team.to_json, head: :ok }
            else
                @team_member = TeamMember.new(user: current_user, team: new_team)
                if @team_member.save
                    refactor_teams new_team

                    # redirect
                    format.html { redirect_to team_url, notice: "You've joined team " + new_team.name }
                    format.json { render json: current_user.to_json, head: :ok }
                else
                    format.json { render json: root_path.errors, status: :unprocessable_entity }
                end
            end
        end
    end

    def ignore
        new_team = Team.find(params[:team])
        TeamInvite.where(recipient: current_user, team: new_team).destroy_all
        respond_to do |format|
            format.html { redirect_to :back, notice: 'Invitation ignored.' }
            format.json { head :no_content }
        end
    end

    private

    def refactor_teams(new_team)
        current_team_members = TeamMember.where(team: current_team) # all other team members
        current_team_admins = current_team_members.where(admin: true) # all admins on the team
        current_team_member = current_team_members.where(user: current_user)
        current_invitation = TeamInvite.where(recipient: current_user, team: new_team)
        
        # make sure there's always a team admin
        unless current_team_admins.present?
            if current_team_members.present?
                new_admin = TeamMember.where(team: current_team).first
                new_admin.admin = true
            else
                # if there's no admin and there are no members,
                # delete the team to keep db clean
                current_team.destroy
                
                # also destroy any invitiations that team 
                # may still have pending
                TeamInvite.where(sender: current_user, team: current_team)
            end
        end

        # delete the old team association
        current_team_member.destroy_all

        # delete the invitiation
        current_invitation.destroy_all
    end

    def set_team_invite
        @team_invite = TeamInvite.find_by(id: params[:id], team: current_team)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_invite_params
        form_params = params.require(:team_invite).permit(:recipient)
        form_params[:recipient] = User.where(username: params[:team_invite][:recipient]).first
        form_params[:sender] = current_user
        form_params[:team] = current_team
        form_params
    end
end
