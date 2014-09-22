class Admin::PlansController < AdminController
  load_resource :plan

  def index
    @plans = Plan.order("created_at desc").page(params[:page]).per(18)
  end


  def show

  end

  def new
    @plan = Plan.new
  end

  def create
    @plan = Plan.new(plan_params)

    if @plan.save
      redirect_to admin_plans_path, notice: "New plan was created successfully."
    else
      render :new
    end
  end

  def edit
    
  end

  def update
    if @plan.update_attributes(plan_params)
      redirect_to admin_plans_path, notice: "Plan was updated successfully."
    else
      render :edit
    end
  end

  def destroy
    if @plan.accounts.count > 0
      redirect_to :back, notice: "Plan has some users, so we can't delete it."
    else
      @plan.destroy
      redirect_to :back, notice: "Plan was deleted succesfully."
    end
  end

  private

  def plan_params
    params.require(:plan).permit(:name, :description, :price, :duration, :status)
  end
end
