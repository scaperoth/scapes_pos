class ProductsController < ApplicationController
    before_filter :authenticate_team!
    before_action :set_product, only: [:show, :edit, :update, :destroy]

    # GET /products
    # GET /products.json
    def index
        @products = Product.where(team: current_team).order(:sku).search(params[:search], params[:page])
    end

    # GET /products/1
    # GET /products/1.json
    def show
    end

    # GET /products/new
    def new
        @product = Product.new
    end

    # GET /products/1/edit
    def edit
    end

    # POST /products
    # POST /products.json
    def create
        @product = Product.new(product_params)

        respond_to do |format|
            if @product.save
                path = team_product_path(current_team, @product)
                format.html { redirect_to path, notice: 'Product was successfully created.' }
                format.json { render :show, status: :created, location: path }
            else
                format.html { render :new }
                format.json { render json: @product.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /products/1
    # PATCH/PUT /products/1.json
    def update
        respond_to do |format|
            if @product.update(product_params)
                path = team_product_path(current_team, @product)
                format.html { redirect_to path, notice: 'Product was successfully updated.' }
                format.json { render :show, status: :ok, location: path }
            else
                format.html { render :edit }
                format.json { render json: @product.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /products/1
    # DELETE /products/1.json
    def destroy
        @product.destroy
        respond_to do |format|
            format.html { redirect_to team_products_path, notice: 'Product was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    def search_by_sku
        respond_to do |format|
          if(params[:sku].present?)
            @product = Product.where(team: current_team).find_by(sku: params[:sku])
            return_hash = @product.as_json
            product_category = @product.category
            return_hash[:price] = product_category.price if product_category.present?
            format.html { render json: return_hash, status: :ok }
            format.json { render json: return_hash, status: :ok }
          else
            format.html { render json: {}, status: :ok }
            format.json { render json: {}, status: :ok }
          end
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_product
        @product = Product.find_by(id: params[:id], team_id: current_team)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
        form_params = params.require(:product).permit(:sku, :description, :price)
        form_params[:team_id] = current_team.id
        form_params
    end
end
