class MyMailer < ActionMailer::Base

  def send_mail(m_to, m_from, m_subject, m_body)
    mail(
      :to => m_to,
      :from => m_from,
      :subject => m_subject,
      # Specify :body and :content_type params to send basic emails without a template
      :content_type => "text/plain",
      :body => m_body,
    )
  end

end