class AccountMailer < ActionMailer::Base
  layout 'mail'
  helper :application
  default from: "noreply@opinion7.com"

  def payment_success_mail(subscription_id)
    @subscription = Subscription.find(subscription_id)
    @account = @subscription.account

    if @subscription.invoice_file.file
      attachments["Invoice_#{@subscription.id}.pdf"] = @subscription.invoice_file.read
    end
    
    mail(subject: "[Opinion7] Your payment has been completed.", to: @account.email)
  end
end
