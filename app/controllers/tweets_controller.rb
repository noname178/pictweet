class TweetsController < ApplicationController

  before_action :move_to_index, except: :index

  def index
    @tweets = Tweet.includes(:user).page(params[:page]).per(5).order('updated_at DESC')
  end

  def show
    @tweet = Tweet.find(params[:id])
    @comments = @tweet.comments.includes(:user)
  end

  def new
  end

  def edit
  end

  def update
    tweet = Tweet.find(params[:id])
    tweet.update(tweet_params)
    if tweet.save
      redirect_to root_path
    else
      render 'edit'
    end
  end

  def create
    Tweet.create(image: tweet_params[:image], text: tweet_params[:text], user_id: current_user.id)
    redirect_to root_path
  end

  def destroy
    tweet = Tweet.find(params[:id])
    if tweet.id == current_user.id
      tweet.destroy
      redirect_to root_path
    end
  end

  private

  def tweet_params
    params.permit(:image, :text)
  end

  def move_to_index
    redirect_to action: :index unless user_signed_in?
  end
end
