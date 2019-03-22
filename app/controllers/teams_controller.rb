class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team, only: %i[show edit update destroy change_owner]
  before_action :only_owner_can_edit, only: %i[edit]

  def index
    @teams = Team.all
  end

  def show
    @working_team = @team
    change_keep_team(current_user, @team)
  end

  def new
    @team = Team.new
  end

  def edit; end

  def create
    @team = Team.new(team_params)
    @team.owner = current_user
    if @team.save
      @team.invite_member(@team.owner)
      redirect_to @team, notice: 'チーム作成に成功しました！'
    else
      flash.now[:error] = '保存に失敗しました、、'
      render :new
    end
  end

  def update
    if @team.owner = current_user
      @team.update(team_params)
      redirect_to @team, notice: 'チーム更新に成功しました！'
    else
      flash.now[:error] = '保存に失敗しました、、'
      render :edit
    end
  end

  def destroy
    @team.destroy
    redirect_to teams_url, notice: 'チーム削除に成功しました！'
  end

  def dashboard
    @team = current_user.keep_team_id ? Team.find(current_user.keep_team_id) : current_user.teams.first
  end

  def change_owner
    @team.owner = User.find_by(id: @team.assigns.find(params[:assign].to_i).user_id)
    if @team.save
      ChangeOwnerMailer.change_owner_mail(@team).deliver
      redirect_to team_url, notice: 'チームリーダーを変更しました！'
    end
  end

  private

  def set_team
    @team = Team.friendly.find(params[:id])
  end

  def team_params
    params.fetch(:team, {}).permit %i[name icon icon_cache owner_id keep_team_id user_id]
  end

  def only_owner_can_edit
    unless @team.owner == current_user
      redirect_to team_url, notice: 'チームリーダー以外は編集出来ません！'
    end
  end
end
