class SaleDetailsController < ApplicationController
    include EventsHelper

    before_filter :authenticate_team!

    before_action :set_sale_detail, only: [:show, :edit, :update, :destroy]

    # GET /sales
    # GET /sales.json
    def index
        @sale_details = SaleDetails.where(team: current_team)
    end

    # GET /sales/1
    # GET /sales/1.json
    def show
    end

    # GET /sales/new
    def new
        @sale_detail = SaleDetail.new
    end

    # GET /sales/1/edit
    def edit
    end

    # POST /sales
    # POST /sales.json
    def create
        @sale_detail = SaleDetail.new(sale_detail_params)
        respond_to do |format|
            if @sale_detail.save
                format.html { redirect_to team_sale_detail_url(@sale_detail), notice: 'Sale Detail was successfully created.' }
                format.json { render :show, status: :created, location: team_event_sale_detail_url }
            else
                format.html { render :new }
                format.json { render json: @sale_detail.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /sales/1
    # PATCH/PUT /sales/1.json
    def update
        respond_to do |format|
            if @sale_detail.update(sale_params)
                format.html { redirect_to team_sale_detail_url(@sale_detail), notice: 'Sale Detail was successfully updated.' }
                format.json { render :show, status: :ok, location: @sale_detail }
            else
                format.html { render :edit }
                format.json { render json: @sale_detail.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /sales/1
    # DELETE /sales/1.json
    def destroy
        @sale_detail.destroy
        respond_to do |format|
            format.html { redirect_to :back, notice: 'Sale Detail was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_sale_detail
        @sale = Sale.where(event_id: Event.where(team: current_team))
        @sale_detail = SaleDetail.find_by(id: params[:id], sale_id: sale)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sale_detail_params
        params.require(:sale_detail).permit(:id)
    end
  end
