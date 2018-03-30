class ListsController < ApplicationController
  before_action :set_list , only: [:show, :edit, :update, :destroy, :list_tasks]

  def index
    @lists = List.all
  end

  def list_tasks
    @tasks = @list.tasks.all
    respond_to(&:js)
  end

  def show
    respond_to(&:js)
  end

  def new
    @list = List.new
    respond_to(&:js)
  end

  def edit
    respond_to(&:js)
  end

  def create
    @list = List.new(list_params)
    respond_to do |format|
      if @list.save
        format.html { redirect_to root_path, remote: true, notice: "List was successfully created." }
        format.json { render :show, status: :created, location: @list }
      else
        format.html { redirect_to root_path, notice: "Title can't be blank" }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @list.update(list_params)
        format.html { redirect_to root_path, remote: true, notice: 'List was successfully updated.' }
        format.json { render :show, status: :ok, location: @list }
      else
        format.html { redirect_to root_path, notice: "Title can't be blank" }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @list.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'List was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
    def set_list
      @list = List.find(params[:id])
    end

    def list_params
      params.require(:list).permit(:title)
    end
end
