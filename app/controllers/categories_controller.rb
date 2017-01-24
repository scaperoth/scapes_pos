class CategoriesController < ApplicationController
  before_filter :authenticate_team!
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  # GET /categories
  # GET /categories.json
  def index
    @categories = Category.where(team_id: current_team)
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = Category.new(category_params)
    
    respond_to do |format|
      if @category.save
        set_product_category @category
        format.html { redirect_to team_categories_path, notice: 'Category was successfully created.' }
        format.json { render :show, status: :created, location: team_categories_path }
      else
        format.html { render :new }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    respond_to do |format|
      if @category.update(category_params)
        set_product_category @category  
        format.html { redirect_to team_categories_path, notice: 'Category was successfully updated.' }
        format.json { render :show, status: :ok, location: team_categories_path }
      else
        format.html { render :edit }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @category.destroy
    respond_to do |format|
      format.html { redirect_to team_categories_url, notice: 'Category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find_by(id: params[:id], team_id: current_team)
    end
    
    def set_product_category(category)
      abort
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
      form_params = params.require(:category).permit(:name, :price)
      form_params[:team_id] = current_team.id
      form_params[:regex] = params[:regex]
      form_params
    end
end
