# frozen_string_literal:true

class WorkoutTagsController < ApplicationController
  before_action :set_workout_tag, only: [:show, :edit, :update, :destroy]

  # GET /workout_tags
  def index
    @workout_tags = workout_tags.all
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
      redirect_to @workout_tag, notice: I18n.t("workout_tags.flash.success.create")
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /workout_tags/1
  def update
    if @workout_tag.update(workout_tag_params)
      redirect_to @workout_tag, notice: I18n.t("workout_tags.flash.success.update")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /workout_tags/1
  def destroy
    @workout_tag.destroy
    redirect_to workout_tags_url, notice: I18n.t("workout_tags.flash.success.destroy")
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_workout_tag
    @workout_tag = workout_tags.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def workout_tag_params
    params.require(:workout_tag).permit(:name)
  end

  def workout_tags
    WorkoutTag.for_user(current_user)
  end
end
