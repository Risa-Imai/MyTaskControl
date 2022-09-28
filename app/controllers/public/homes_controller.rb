class Public::HomesController < ApplicationController
  def top
    @task = Task.new
  end

  def about
  end
end
