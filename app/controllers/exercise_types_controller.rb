# frozen_string_literal: true

class ExerciseTypesController < ApplicationController
  before_action(:load_related_models, only: [:new, :edit])

  # GET /exercise_types
  def index
    @exercise_types = policy_scope(ExerciseType).includes(:equipment).all
  end

  # GET /exercise_types/1
  def show
    @exercise_type =
      policy_scope(ExerciseType)
      .includes(:equipment, exercises: [:workout, :exercise_sets])
      .find(params[:id])
  end

  # GET /exercise_types/new
  def new
    @exercise_type = ExerciseType.new
  end

  # GET /exercise_types/1/edit
  def edit
    @exercise_type = policy_scope(ExerciseType).includes(:equipment).find(params[:id])
  end

  # POST /exercise_types
  def create
    @exercise_type = ExerciseType.new(exercise_type_params.merge(user: current_user))

    if @exercise_type.save
      respond_to do |format|
        format.html { redirect_to(exercise_types_path) }
        format.turbo_stream
      end
    else
      load_related_models
      render(:new, status: :unprocessable_entity)
    end
  end

  # PATCH/PUT /exercise_types/1
  def update
    @exercise_type = policy_scope(ExerciseType).find(params[:id])
    if @exercise_type.update(exercise_type_params)
      respond_to do |format|
        format.html { redirect_to(exercise_types_path) }
        format.turbo_stream
      end
    else
      load_related_models
      render(:edit, status: :unprocessable_entity)
    end
  end

  # DELETE /exercise_types/1
  def destroy
    @exercise_type = policy_scope(ExerciseType).find(params[:id])
    @exercise_type.destroy
    respond_to do |format|
      format.html { redirect_to(exercise_types_path) }
      format.turbo_stream
    end
  end

  private

  def load_related_models
    @exercise_type_tags = policy_scope(ExerciseTypeTag).all
    @equipment = policy_scope(Equipment).all
  end

  # Only allow a list of trusted parameters through.
  def exercise_type_params
    params.expect(exercise_type: [:name, { tag_ids: [], equipment_ids: [] }])
  end
end
