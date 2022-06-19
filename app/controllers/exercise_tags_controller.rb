# frozen_string_literal:true

class ExerciseTagsController < ApplicationController
  before_action :set_exercise_tag, only: [:show, :edit, :update, :destroy]

  # GET /exercise_tags
  def index
    @exercise_tags = exercise_tags.all
  end

  # GET /exercise_tags/1
  def show; end

  # GET /exercise_tags/new
  def new
    @exercise_tag = ExerciseTag.new
  end

  # GET /exercise_tags/1/edit
  def edit; end

  # POST /exercise_tags
  def create
    @exercise_tag = ExerciseTag.new(exercise_tag_params.merge({ user: current_user }))

    if @exercise_tag.save
      redirect_to @exercise_tag, notice: I18n.t("exercise_tags.flash.success.create")
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /exercise_tags/1
  def update
    if @exercise_tag.update(exercise_tag_params)
      redirect_to @exercise_tag, notice: I18n.t("exercise_tags.flash.success.update")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /exercise_tags/1
  def destroy
    @exercise_tag.destroy
    redirect_to exercise_tags_url, notice: I18n.t("exercise_tags.flash.success.destroy")
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_exercise_tag
    @exercise_tag = exercise_tags.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def exercise_tag_params
    params.require(:exercise_tag).permit(:name)
  end

  def exercise_tags
    ExerciseTag.for_user(current_user)
  end
end
