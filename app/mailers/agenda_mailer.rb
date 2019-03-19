class AgendaMailer < ApplicationMailer
    def agenda_mail(agenda)
        @agenda = agenda
        @members = @agenda.team.users
        mail to:@members.map(&:email).join(","), subject: "アジェンダ削除の通知メール"
    end
end
