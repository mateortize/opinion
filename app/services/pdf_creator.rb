class PdfCreator

  def self.render_invoice(subscription)
    content = ApplicationController.new.render_to_string(
      template: "account/subscriptions/invoice.pdf.haml", 
      layout: "layouts/pdf.html.haml",
      locals: {
        billing_address: subscription.billing_address,
        subscription:    subscription,
        account:         subscription.account,
        plan:            subscription.plan
      }
    )

    WickedPdf.new.pdf_from_string(content)
  end

end
