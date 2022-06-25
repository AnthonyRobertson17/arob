# frozen_string_literal:true

class ExerciseTypeTagsController < ApplicationController
  before_action :set_exercise_type_tag, only: [:show, :edit, :update, :destroy]

  # GET /exercise_type_tags
  def index
    @exercise_type_tags = exercise_type_tags.all
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
      redirect_to @exercise_type_tag, notice: I18n.t("exercise_type_tags.flash.success.create")
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /exercise_type_tags/1
  def update
    if @exercise_type_tag.update(exercise_type_tag_params)
      redirect_to @exercise_type_tag, notice: I18n.t("exercise_type_tags.flash.success.update")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /exercise_type_tags/1
  def destroy
    @exercise_type_tag.destroy
    redirect_to exercise_type_tags_url, notice: I18n.t("exercise_type_tags.flash.success.destroy")
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_exercise_type_tag
    @exercise_type_tag = exercise_type_tags.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def exercise_type_tag_params
    params.require(:exercise_type_tag).permit(:name)
  end

  def exercise_type_tags
    ExerciseTypeTag.for_user(current_user)
  end
end
