class ChangeOwnerMailer < ApplicationMailer
    def change_owner_mail(team)
        @team = team
        mail to: @team.owner, subject: "チームリーダー変更の通知メール"
    end
end
