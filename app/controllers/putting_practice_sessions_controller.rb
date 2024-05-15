# frozen_string_literal: true

class PuttingPracticeSessionsController < ApplicationController
  before_action(:set_putting_practice_session, only: [:edit, :update, :destroy])

  def index
    @putting_practice_sessions = policy_scope(PuttingPracticeSession).order(id: :desc)
  end

  def show
    @putting_practice_session = policy_scope(PuttingPracticeSession).includes(:practice_putts).find(params[:id])
  end

  def new
    @putting_practice_session = PuttingPracticeSession.new
  end

  def edit; end

  def create
    @putting_practice_session = policy_scope(PuttingPracticeSession)
                                .build(putting_practice_session_params.merge(user: current_user))

    if @putting_practice_session.save
      redirect_to(@putting_practice_session)
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  def update
    if @putting_practice_session.update(putting_practice_session_params)
      respond_to do |format|
        format.html { redirect_to(@putting_practice_session) }
        format.turbo_stream
      end
    else
      render(:edit, status: :unprocessable_entity)
    end
  end

  def destroy
    @putting_practice_session.destroy

    redirect_to(golf_path, status: :see_other)
  end

  def putt; end

  private

  def set_putting_practice_session
    @putting_practice_session = PuttingPracticeSession.find(params[:id])
  end

  def putting_practice_session_params
    params.require(:putting_practice_session).permit(:hole_size, :hole_distance)
  end
end
