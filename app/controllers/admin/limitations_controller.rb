class Admin::LimitationsController < AdminController
  before_filter :load_package
  before_filter :load_limitation, only: [:update, :destroy, :edit]

  def index
  end

  def new
    @limitation = Limitation.new
  end

  def show
  end

  def edit
  end

  def create
    @limitation = @package.limitations.new(limitation_params)

    if @limitation.save
      redirect_to edit_admin_package_path(@package), notice: "New limitation is created successfully."
    else
      render :new
    end
  end

  def update
    if @limitation.update_attributes(limitation_params)
      redirect_to edit_admin_package_path(@package), notice: "Limitation is updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @limitation.destroy
    redirect_to edit_admin_package_path(@package)
  end

  private

  def load_package
    @package = Package.find(params[:package_id])
  end

  def load_limitation
    @limitation = Limitation.find(params[:id])
  end

  def limitation_params
    params.require(:limitation).permit(:key, :value, :description)
  end
end