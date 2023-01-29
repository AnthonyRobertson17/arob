# frozen_string_literal: true

class EquipmentController < ApplicationController
  before_action(:set_equipment, only: [:edit, :update, :destroy])
  before_action(:set_gyms, only: [:new, :edit])

  # GET /equipment
  def index
    @equipment_list = policy_scope(Equipment).all
  end

  # GET /equipment/1
  def show
    @equipment = policy_scope(Equipment).find(params[:id])
  end

  # GET /equipment/new
  def new
    @equipment = Equipment.new
  end

  # GET /equipment/1/edit
  def edit; end

  # POST /equipment
  def create
    @equipment = Equipment.new(equipment_params.merge(user: current_user))

    if @equipment.save
      respond_to do |format|
        format.html { redirect_to(equipment_index_url) }
        format.turbo_stream
      end
    else
      set_gyms
      render(:new, status: :unprocessable_entity)
    end
  end

  # PATCH/PUT /equipment/1
  def update
    if @equipment.update(equipment_params)
      respond_to do |format|
        format.html { redirect_to(equipment_index_url) }
        format.turbo_stream
      end
    else
      set_gyms
      render(:edit, status: :unprocessable_entity)
    end
  end

  # DELETE /equipment/1
  def destroy
    @equipment.destroy
    redirect_to(equipment_index_url, status: :see_other)
  end

  private

  def set_equipment
    @equipment = policy_scope(Equipment).find(params[:id])
  end

  def set_gyms
    @gyms = policy_scope(Gym).all
  end

  def equipment_params
    params.require(:equipment).permit(:name, { gym_ids: [] })
  end
end
