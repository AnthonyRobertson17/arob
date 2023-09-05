# frozen_string_literal:true

class ServingUnitsController < ApplicationController
  def index
    @serving_units = policy_scope(ServingUnit).all
  end

  def show
    @serving_unit = policy_scope(ServingUnit).find(params[:id])
  end

  def new
    @serving_unit = ServingUnit.new
  end

  def edit
    @serving_unit = policy_scope(ServingUnit).find(params[:id])
  end

  def create
    @serving_unit = ServingUnit.new(serving_unit_params.merge(user: current_user))

    if @serving_unit.save
      respond_to do |format|
        format.html { redirect_to(serving_units_path) }
        format.turbo_stream
      end
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  def update
    @serving_unit = policy_scope(ServingUnit).find(params[:id])
    if @serving_unit.update(serving_unit_params)
      respond_to do |format|
        format.html { redirect_to(serving_units_path) }
        format.turbo_stream
      end
    else
      render(:edit, status: :unprocessable_entity)
    end
  end

  def destroy
    @serving_unit = policy_scope(ServingUnit).find(params[:id])
    @serving_unit.destroy
    respond_to do |format|
      format.html { redirect_to(serving_units_path) }
      format.turbo_stream
    end
  end

  private

  def serving_unit_params
    params.require(:serving_unit).permit(:name, :abbreviation)
  end
end
