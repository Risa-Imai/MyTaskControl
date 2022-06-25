class Public::RelationshipsController < ApplicationController
  before_action :authenticate_customer!
  # フォローするとき
  def create
    @customer = Customer.find(params[:customer_id])
    current_customer.follow(params[:customer_id])
    @following_customers = @customer.followings
    @follower_customers = @customer.followers
    # redirect_to request.referer
  end
  # フォロー外すとき
  def destroy
    @customer = Customer.find(params[:customer_id])
    current_customer.unfollow(params[:customer_id])
    @following_customers = @customer.followings
    @follower_customers = @customer.followers
    # redirect_to request.referer
  end
  # フォロー一覧
  def followings
    @customer = Customer.find(params[:customer_id])
    @following_customers = @customer.followings
  end
  # フォロワー一覧
  def followers
    @customer = Customer.find(params[:customer_id])
    @follower_customers = @customer.followers
  end
end
