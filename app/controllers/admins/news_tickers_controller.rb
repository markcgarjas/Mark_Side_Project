class Admins::NewsTickersController < AdminController
  before_action :set_news_ticker, only: [:edit, :update, :destroy]

  def index
    @news_tickers = NewsTicker.includes(:admin).all
  end

  def new
    @news_ticker = NewsTicker.new
  end

  def create
    @news_ticker = NewsTicker.new(news_ticker_params)
    @news_ticker.admin = current_admins_user
    if @news_ticker.save
      flash[:notice] = "Successfully Created"
      redirect_to admins_news_tickers_path
    else
      flash[:notice] = @news_ticker.errors.full_messages.join(", ")
      redirect_to new_admins_news_ticker_path
    end
  end

  def edit; end

  def update
    @news_ticker.update(news_ticker_params)
    if @news_ticker.save
      flash[:notice] = "Successfully Updated"
      redirect_to admins_news_tickers_path
    else
      flash[:notice] = @news_ticker.errors.full_messages.join(", ")
      redirect_to edit_admins_news_ticker_path
    end
  end

  def destroy
    if @news_ticker.destroy
      flash[:notice] = "Successfully Deleted"
      redirect_to admins_news_tickers_path
    else
      flash[:notice] = @news_ticker.errors.full_messages.join(", ")
      redirect_to edit_admins_news_ticker_path
    end
  end

  private

  def news_ticker_params
    params.require(:news_ticker).permit(:content, :status)
  end

  def set_news_ticker
    @news_ticker = NewsTicker.find(params[:id])
  end
end
