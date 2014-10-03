class Admin::PackagesController < AdminController
  before_filter :load_package, only: [:update, :destroy, :edit]

  def index
    @packages = Package.all
  end

  def new
    @package = Package.new
  end

  def show
  end

  def edit
  end

  def create
    @package = @plan.packages.new(package_params)

    if @package.save
      redirect_to edit_admin_package_path(@plan), notice: "New package is created successfully."
    else
      render :new
    end
  end

  def update
    if @package.update_attributes(package_params)
      redirect_to edit_admin_package_path(@plan), notice: "package is updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @package.destroy
    redirect_to admin_packages_path
  end

  private

  def load_package
    @package = Package.find(params[:id])
  end

  def package_params
    params.require(:package).permit(:name, :description, :position, :status)
  end
end