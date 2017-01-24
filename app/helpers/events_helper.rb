module EventsHelper
  
  
  def active_event
    Event.find_by(team: current_team, active: true)
  end  
    
end
