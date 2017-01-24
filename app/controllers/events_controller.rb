class EventsController < ApplicationController
  before_filter :authenticate_team!
  after_filter :insure_active_event, only: [:create, :update, :destroy]
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    @events = Event.where(team: current_team)
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        set_event_unique_active @event if @event.active
        format.html { redirect_to team_events_url, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: team_events_url }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        set_event_unique_active @event if @event.active
        format.html { redirect_to team_events_url, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: team_events_url }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    set_event_unique_active Event.first
    respond_to do |format|
      format.html { redirect_to team_events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_event_unique_active(event)
      if event.present?
        # set all other events to false if this one is set to active 
        Event.where('id != ?', event.id).update_all(active: false)
        event.active = true
        event.save
      end
    end
    
    def insure_active_event
      active_event = Event.find_by(team: current_team, active: true)
      unless active_event.present?
        first_available = Event.where(team: current_team).first
        set_event_unique_active first_available
        flash.clear
        flash[:alert] = "Must have exactly one active event. Setting \""+first_available.name+"\" to active."
      end
    end
    
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find_by(id: params[:id], team: current_team)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      form_params = params.require(:event).permit(:name, :active)
      form_params[:team_id] = current_team.id
      form_params
    end
end
