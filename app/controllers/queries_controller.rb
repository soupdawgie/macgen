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
    locals amount: @query.amount,
           vendor: @query.vendor,
           position: set_start(@query)
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
    flash[:success] = "Snippet deleted"
    redirect_to root_path
  end

  def set_start(obj)
    # 1000000 in hexadecimal
    base  = 16777216
    # convert the entered octets to decimals
    start = obj.start.scan(/.{2}/).map { |n| n.hex }
    # set starting point for the loop
    base + start[2] + (start[1] * 256) + (start[0] * 65536)
  end
end

  private

  def query_params
    params.require(:query).permit(:amount, :vendor, :start, :separator)
  end

  def locals(values)
    render locals: values
  end
