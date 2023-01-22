# frozen_string_literal: true

class ExerciseTypesController < ApplicationController
  before_action(:set_exercise_type, only: [:show, :edit, :update, :destroy])
  before_action(:set_exercise_type_tags, only: [:new, :edit])

  # GET /exercise_types
  def index
    @exercise_types = policy_scope(ExerciseType).all.order("lower(name)")
  end

  # GET /exercise_types/1
  def show; end

  # GET /exercise_types/new
  def new
    @exercise_type = ExerciseType.new
  end

  # GET /exercise_types/1/edit
  def edit; end

  # POST /exercise_types
  def create
    @exercise_type = ExerciseType.new(exercise_type_params.merge(user: current_user))

    if @exercise_type.save
      respond_to do |format|
        format.html { redirect_to(exercise_types_path) }
        format.turbo_stream
      end
    else
      set_exercise_type_tags
      render(:new, status: :unprocessable_entity)
    end
  end

  # PATCH/PUT /exercise_types/1
  def update
    if @exercise_type.update(exercise_type_params)
      respond_to do |format|
        format.html { redirect_to(exercise_types_path) }
        format.turbo_stream
      end
    else
      set_exercise_type_tags
      render(:edit, status: :unprocessable_entity)
    end
  end

  # DELETE /exercise_types/1
  def destroy
    @exercise_type.destroy
    respond_to do |format|
      format.html { redirect_to(exercise_types_path) }
      format.turbo_stream
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_exercise_type
    @exercise_type = policy_scope(ExerciseType).find(params[:id])
  end

  def set_exercise_type_tags
    @exercise_type_tags = policy_scope(ExerciseTypeTag).all.order("lower(name)")
  end

  # Only allow a list of trusted parameters through.
  def exercise_type_params
    params.require(:exercise_type).permit([:name, { tag_ids: [] }])
  end
end
