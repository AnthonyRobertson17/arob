# frozen_string_literal:true

class ServingDefinitionsController < ApplicationController
  def index
    @serving_definitions = policy_scope(ServingDefinition).all
  end

  def new
    @serving_definition = ServingDefinition.new
  end

  def edit
    @serving_definition = policy_scope(ServingDefinition).find(params[:id])
  end

  def create
    @serving_definition = ServingDefinition.new(serving_definition_params.merge(user: current_user))

    if @serving_definition.save
      respond_to do |format|
        format.html { redirect_to(serving_definitions_path) }
        format.turbo_stream
      end
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  def update
    @serving_definition = policy_scope(ServingDefinition).find(params[:id])
    if @serving_definition.update(serving_definition_params)
      respond_to do |format|
        format.html { redirect_to(serving_definitions_path) }
        format.turbo_stream
      end
    else
      render(:edit, status: :unprocessable_entity)
    end
  end

  def destroy
    @serving_definition = policy_scope(ServingDefinition).find(params[:id])
    @serving_definition.destroy
    respond_to do |format|
      format.html { redirect_to(serving_definitions_path) }
      format.turbo_stream
    end
  end

  private

  def serving_definition_params
    params.expect(serving_definition: [:food_id, :food_group_id, :serving_unit_id, :serving_quantity])
  end
end
