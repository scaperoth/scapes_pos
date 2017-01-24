class TeamMembersController < ApplicationController
    include TeamsHelper
    before_filter :authenticate_team!
    before_action :set_team_member, only: [:show, :edit, :update, :destroy]

    # GET /team_members
    # GET /team_members.json
    def index
        @team_members = TeamMember.where(team: current_team)
        @teams = TeamMember.where(user: current_user)
    end

    # GET /team_members/1
    # GET /team_members/1.json
    def show
    end

    # GET /team_members/new
    def new
        @team_member = TeamMember.new
    end

    # GET /team_members/1/edit
    def edit
    end

    # POST /team_members
    # POST /team_members.json
    def create
        @team_member = TeamMember.new(team_member_params)

        respond_to do |format|
            if @team_member.save
                format.html { redirect_to @team_member, notice: 'Team member was successfully created.' }
                format.json { render :show, status: :created, location: @team_member }
            else
                format.html { render :new }
                format.json { render json: @team_member.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /team_members/1
    # PATCH/PUT /team_members/1.json
    def update
        respond_to do |format|
            if @team_member.update(team_member_params)
                format.html { redirect_to @team_member, notice: 'Team member was successfully updated.' }
                format.json { render :show, status: :ok, location: @team_member }
            else
                format.html { render :edit }
                format.json { render json: @team_member.errors, status: :unprocessable_entity }
            end
        end
    end
    
    
    # DELETE /team_members/1
    # DELETE /team_members/1.json
    def destroy
        @team_member.destroy
        # if the user leaves the team
        # and is not on any other team (if multiple teams allowed)
        # then give user newly created team name
        give_user_rand_team_name unless user_has_team?
        respond_to do |format|
            format.html { redirect_to :back, notice: 'Team member was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_team_member
      @team_member = TeamMember.where(team: current_team).find(params[:id])
      
      # after setting team member, make sure user has access to this account
      unless (team_admin? && (current_team == @team_member.team)) || (@team_member.user == current_user)
          # If the user came from a page, we can send them back.  Otherwise, send
          # them to the root path.
          fallback_redirect = if request.env['HTTP_REFERER']
                                  :back
                              elsif defined?(root_path)
                                  root_path
                              else
                                  '/'
                              end

          redirect_to fallback_redirect, flash: { alert: 'You do not have permission to view this page.' }
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_member_params
        params.require(:team_member).permit(:team_id, :user_id)
    end
end
