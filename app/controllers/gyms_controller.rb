# frozen_string_literal: true

class GymsController < ApplicationController
  before_action(:set_gym, only: [:edit, :update, :destroy])

  # GET /gyms
  def index
    @gyms = policy_scope(Gym).includes(:equipment).all.order("lower(name)")
  end

  # GET /gyms/1
  def show
    @gym = policy_scope(Gym).find(params[:id])
  end

  # GET /gyms/new
  def new
    @gym = Gym.new
  end

  # GET /gyms/1/edit
  def edit; end

  # POST /gyms
  def create
    @gym = Gym.new(gym_params.merge(user: current_user))

    if @gym.save
      respond_to do |format|
        format.html { redirect_to(gym_path(@gym)) }
        format.turbo_stream
      end
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  # PATCH/PUT /gyms/1
  def update
    if @gym.update(gym_params)
      respond_to do |format|
        format.html { redirect_to(@gym) }
        format.turbo_stream
      end
    else
      render(:edit, status: :unprocessable_entity)
    end
  end

  # DELETE /gyms/1
  def destroy
    @gym.destroy
    redirect_to(gyms_url, status: :see_other)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_gym
    @gym = policy_scope(Gym).find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def gym_params
    params.require(:gym).permit(:name)
  end
end
