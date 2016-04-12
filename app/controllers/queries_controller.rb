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
    render template: 'queries/show',
           locals:  { amount:   @query.amount,
                      vendor:   @query.vendor,
                      position: set_start(@query),
                      spr:      @query.separator,
                      }
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
    # Base is 1000000 in hexadecimal, zeros are basically octets
    base  = 16777216
    # Split input to three octets and convert to decimal
    start = obj.start.scan(/.{2}/).map { |n| n.hex }
    # Set 6th octet by adding to base,
    #     5th by adding and multiplying by 256,
    #     4th by adding and multiplying by 65536.
    # Then this value's incremented inside the cycle
    start = base + start[2] + (start[1] * 256) + (start[0] * 65536)
  end
end

  private

    def query_params
      params.require(:query).permit(:amount, :vendor, :start, :separator)
    end
