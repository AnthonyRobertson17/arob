# frozen_string_literal:true

class ExerciseTypeTagsController < ApplicationController
  before_action :set_exercise_type_tag, only: [:show, :edit, :update, :destroy]

  # GET /exercise_type_tags
  def index
    @exercise_type_tags = policy_scope(ExerciseTypeTag).all
  end

  # GET /exercise_type_tags/1
  def show; end

  # GET /exercise_type_tags/new
  def new
    @exercise_type_tag = ExerciseTypeTag.new
  end

  # GET /exercise_type_tags/1/edit
  def edit; end

  # POST /exercise_type_tags
  def create
    @exercise_type_tag = ExerciseTypeTag.new(exercise_type_tag_params.merge({ user: current_user }))

    if @exercise_type_tag.save
      respond_to do |format|
        format.html { redirect_to(exercise_type_tag_path(@exercise_type_tag)) }
        format.turbo_stream
      end
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  # PATCH/PUT /exercise_type_tags/1
  def update
    if @exercise_type_tag.update(exercise_type_tag_params)
      respond_to do |format|
        format.html { redirect_to(exercise_type_tag_path(@exercise_type_tag)) }
        format.turbo_stream
      end
    else
      render(:edit, status: :unprocessable_entity)
    end
  end

  # DELETE /exercise_type_tags/1
  def destroy
    @exercise_type_tag.destroy
    respond_to do |format|
      format.html { redirect_to(exercise_type_tags_path) }
      format.turbo_stream
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_exercise_type_tag
    @exercise_type_tag = policy_scope(ExerciseTypeTag).find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def exercise_type_tag_params
    params.require(:exercise_type_tag).permit(:name)
  end
end
