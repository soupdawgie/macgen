class QueriesController < ApplicationController
  def index
    @queries = Query.paginate(page: params[:page], per_page: 20)
  end

  def new
    @query = Query.new
  end

  def create
    @query = Query.new(query_params)
    if @query.save
      flash[:success] = "Query is saved!"
      redirect_to @query
    else
      render 'new'
    end
  end

  def show
    @query = Query.find(params[:id])
  end

  def edit
    @query = Query.find(params[:id])
  end

  def update
    @query = Query.find(params[:id])
    if @query.update_attributes(query_params)
      flash[:success] = "Query successfully updated!"
      redirect_to @query
    else
      render 'edit'
    end
  end

  def destroy
    Query.find(params[:id]).destroy
    flash[:success] = "Snippet deleted."
    redirect_to root_path
  end
end

  private

    def query_params
      params.require(:query).permit(:amount, :vendor, :start, :separator)
    end
