# frozen_string_literal:true

class WorkoutTagsController < ApplicationController
  before_action :set_workout_tag, only: [:show, :edit, :update, :destroy]

  # GET /workout_tags
  def index
    @workout_tags = policy_scope(WorkoutTag).all
  end

  # GET /workout_tags/1
  def show; end

  # GET /workout_tags/new
  def new
    @workout_tag = WorkoutTag.new
  end

  # GET /workout_tags/1/edit
  def edit; end

  # POST /workout_tags
  def create
    @workout_tag = WorkoutTag.new(workout_tag_params.merge({ user: current_user }))

    if @workout_tag.save
      respond_to do |format|
        format.html { redirect_to(workout_tag_path(@workout_tag)) }
        format.turbo_stream
      end
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  # PATCH/PUT /workout_tags/1
  def update
    if @workout_tag.update(workout_tag_params)
      respond_to do |format|
        format.html { redirect_to(workout_tag_path(@workout_tag)) }
        format.turbo_stream
      end
    else
      render(:edit, status: :unprocessable_entity)
    end
  end

  # DELETE /workout_tags/1
  def destroy
    @workout_tag.destroy
    respond_to do |format|
      format.html { redirect_to(workout_tags_path) }
      format.turbo_stream
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_workout_tag
    @workout_tag = policy_scope(WorkoutTag).find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def workout_tag_params
    params.expect(workout_tag: [:name])
  end
end
