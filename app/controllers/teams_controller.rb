class TeamsController < ApplicationController
    before_filter :authenticate_team!
    before_action :set_team, only: [:show, :edit, :update, :destroy]
    before_action :set_team_members, only: [:show]
    before_action :set_team_invites, only: [:show]

    # GET /teams/1
    # GET /teams/1.json
    def show
    end

    # GET /teams/new
    def new
        @team = Team.new
    end

    # GET /teams/1/edit
    def edit
        unless team_admin?
            respond_to do |format|
                format.html { redirect_to @team, flash: { alert: 'You do not have access to this page.' } }
                format.json { render :show, status: :created, location: @team }
            end
        end
    end

    # POST /teams
    # POST /teams.json
    def create
        @team = Team.new(team_params)

        respond_to do |format|
            if @team.save
                format.html { redirect_to dashboard_url, notice: 'Team was successfully created.' }
                format.json { render :show, status: :created, location: dashboard_url }
            else
                format.html { render :new }
                format.json { render json: @team.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /teams/1
    # PATCH/PUT /teams/1.json
    def update
        respond_to do |format|
            if @team.update(team_params)
                format.html { redirect_to dashboard_url, notice: 'Team was successfully updated.' }
                format.json { render :show, status: :ok, location: dashboard_url }
            else
                format.html { render :edit }
                format.json { render json: @team.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /teams/1
    # DELETE /teams/1.json
    def destroy
        @team.destroy
        respond_to do |format|
            format.html { redirect_to team_url, notice: 'Team was successfully destroyed.' }
            format.json { head :no_content }
        end
    end


    private

    # Use callbacks to share common setup or constraints between actions.
    def set_team
        @team = current_team
    end
    
    def set_team_members
        @team_members = TeamMember.where(team: current_team)
    end
    
    def set_team_invites
      @team_invites = TeamInvite.where(team: current_team)
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def team_params
        form_params = params.require(:team).permit(:name)
    end
end
