class SalesController < ApplicationController
    include EventsHelper

    before_filter :authenticate_team!

    before_action :set_event
    before_action :set_sale, only: [:show, :edit, :update, :destroy]

    # GET /sales
    # GET /sales.json
    def index
        events = Event.where(team: current_team)
        @sales = Sale.where(event: events)
    end

    # GET /sales/1
    # GET /sales/1.json
    def show
        @sale_details = SaleDetail.where(sale: @sale)
    end

    # GET /sales/new
    def new
        @sale = Sale.new
    end

    # GET /sales/1/edit
    def edit
        @sale_details = SaleDetail.where(sale: @sale)
    end

    # POST /sales
    # POST /sales.json
    def create
        @sale = Sale.new(sale_params)
        @sale.user = current_user
        @sale.total = @sale.total_all
        respond_to do |format|
            if @sale.save
                format.html { redirect_to team_event_sale_url(@sale.event, @sale), notice: 'Sale was successfully created.' }
                format.json { render :show, status: :created, location: team_event_sale_detail_url }
            else
                format.html { render :new }
                format.json { render json: @sale.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /sales/1
    # PATCH/PUT /sales/1.json
    def update
        respond_to do |format|
            if @sale.update(sale_params)
                format.html { redirect_to team_event_sale_url(@sale.event, @sale), notice: 'Sale was successfully updated.' }
                format.json { render :show, status: :ok, location: @sale }
            else
                format.html { render :edit }
                format.json { render json: @sale.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /sales/1
    # DELETE /sales/1.json
    def destroy
        @sale.destroy
        respond_to do |format|
            format.html { redirect_to new_team_event_sale_path(active_event), notice: 'Sale was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_sale
        @sale = Sale.find_by(id: params[:id], event_id: Event.where(team: current_team))
    end

    def set_event
        @event = Event.where(team: current_team).find(params[:event_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sale_params
        form_params = params.require(:sale).permit(:customer, :amount_paid, :change, sale_details_attributes: [:id, :quantity, :total, :_destroy, :price, product_attributes:[:sku]])
      
        if form_params[:sale_details_attributes].present?
            # here we will create a product if we need to because
            # we want the user to be able to, on-the-fly, create their
            # own products. Also, we want the ability to create
            # custom prices that are for one-time use so they are
            # a part of the sale detail model.
            form_params[:sale_details_attributes].each do |k, v|
                # get the product information from the form 
                product = v[:product_attributes]
                product[:price] = form_params[:sale_details_attributes]
      
                # delete the product from the sale_detail
                form_params[:sale_details_attributes][k].delete :product_attributes
      
                # add the product information to the product attributes param
                new_product = Product.find_or_create_by(sku: product[:sku], team: current_team)
      
                # if the price is nil, let's use the user input
                new_product.price = product[:price] if new_product.price.nil?
                new_product.save # save changes
      
                # add a product reference for the new/existing product we got
                form_params[:sale_details_attributes][k][:product_id] = new_product.id
            end
      end
        # set the customer from the name given or creat it if it's new
        form_params[:customer] = Customer.find_or_create_by(name: form_params[:customer])

        # finally, grab the current event and team
        form_params[:event] = active_event

        # return the params
        form_params
    end
end
