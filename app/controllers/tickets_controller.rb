class TicketsController < ApplicationController
  before_action :load_ticket, only: %i(edit update show)
  before_action :check_to_enough_fare, only: :update
  before_action :ckeck_used_ticket, only: [:update, :edit]

  def index
    redirect_to root_path
  end

  def new
    @ticket = Ticket.new
  end

  def create
    @ticket = Ticket.new(ticket_create_params)
    if @ticket.save
      redirect_to [:edit, @ticket], notice: '乗車しました。🚃'
    else
      render :new
    end
  end

  def show
    redirect_to [:edit, @ticket]
  end

  def edit
  end

  def update
    if @ticket.update(ticket_update_params)
      redirect_to root_path, notice: '降車しました。😄'
    else
      render :edit
    end
  end

  private

  def check_to_enough_fare
    exited_gate = Gate.find_by_id(ticket_update_params["exited_gate_id"])
    unless exited_gate.exit?(@ticket)
      redirect_to [:edit, @ticket], alert: '降車駅 では降車できません。'
    end
  end

  def ticket_create_params
    params.require(:ticket).permit(:fare, :entered_gate_id)
  end

  def ticket_update_params
    params.require(:ticket).permit(:exited_gate_id)
  end

  def load_ticket
    @ticket = Ticket.find(params[:id])
  end

  def ckeck_used_ticket
    if @ticket.exited_gate
      redirect_to root_path, alert: '降車済みの切符です。'
    end
  end
end
